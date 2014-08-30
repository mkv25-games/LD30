package net.mkv25.game.controllers;

import net.mkv25.game.event.EventBus;
import net.mkv25.game.models.HexTile;
import net.mkv25.game.models.MapUnit;
import net.mkv25.game.models.PlayableCard;
import net.mkv25.game.models.PlayerModel;
import net.mkv25.game.provider.UnitProvider;
import net.mkv25.game.ui.DeploymentUI;
import net.mkv25.game.ui.MapUI;
import net.mkv25.game.ui.MovementUI;

class MoveUnitController
{
	private var map:MapUI;
	private var movement:MovementUI;
	
	private var activeMovementCard:PlayableCard;
	private var markedLocation:HexTile;
	private var selectedLocation:HexTile;
	
	public function new()
	{
		EventBus.playerWantsTo_moveAUnit.add(suggestUnitMovementOptionsToPlayer);
		EventBus.playerWantsTo_moveUnitAtSelectedLocation.add(suggestMovementOptionsFromSelectedLocation);
		EventBus.playerWantsTo_cancelTheCurrentAction.add(cancelMovement);
		
		EventBus.mapMarkerPlacedOnMap.add(updateMovementAvailability);
		// EventBus.mapMarkerRemovedFromMap.add(disableMovementButton);
	}
	
	public function setup(map:MapUI, movement:MovementUI):Void
	{
		this.map = map;
		this.movement = movement;
	}
	
	function suggestUnitMovementOptionsToPlayer(card:PlayableCard):Void
	{
		this.activeMovementCard = card;
		
		enableMovement();
		
		updateMovementAvailability(markedLocation);
		
		EventBus.displayNewStatusMessage.dispatch("Choose a unit or base to move.");
	}
	
	function suggestMovementOptionsFromSelectedLocation(?model):Void
	{
		// highlight valid, adjacent movement tiles
		if (markedLocation == null)
		{
			return;
		}
		
		selectedLocation = markedLocation.map.getHexTile(markedLocation.q, markedLocation.r);
		var unit:MapUnit = selectUnitForPlayerFrom(selectedLocation, Index.activeGame.activePlayer);
		if (unit != null) 
		{
			map.enableMovementOverlayFrom(markedLocation);
			movement.confirmButton.enable();
			EventBus.displayNewStatusMessage.dispatch("Select a tile to move to.");
		}
		else
		{
			throw "Selected location does not contain a valid unit for the active player.";
		}
	}
	
	function selectUnitForPlayerFrom(hex:HexTile, player:PlayerModel):Null<MapUnit>
	{
		var contents = hex.listContents();
		for (thing in contents)
		{
			if (Std.is(thing, MapUnit))
			{
				var unit:MapUnit = cast thing;
				if (unit.owner == player)
				{
					return unit;
				}
			}
		}
		
		return null;
	}
	
	function cancelMovement(?model)
	{
		this.activeMovementCard = null;
		this.markedLocation = null;
		
		disableMovement();
	}
	
	function enableMovement()
	{
		movement.enable();
		movement.show();
	}
	
	function disableMovement()
	{
		movement.disable();
		movement.hide();
		
		map.disableMovementOverlay();
	}
	
	function updateMovementAvailability(marker:HexTile):Void
	{
		this.markedLocation = marker;
		if (activeMovementCard == null)
		{
			movement.moveButton.disable();
			movement.confirmButton.disable();
			return;
		}
		
		// check that a player owned base exists in a neighbouring tile
		if (markedLocation != null)
		{
			var location:HexTile = markedLocation.map.getHexTile(markedLocation.q, markedLocation.r);
			if (location.containsUnit(Index.activeGame.activePlayer))
			{
				// Rule: players can only move their own units
				movement.moveButton.enable();
				return;
			}
		}
		
		movement.moveButton.disable();
	}
}