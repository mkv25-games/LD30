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
	private var markedHex:HexTile;
	
	public function new()
	{
		EventBus.playerWantsTo_moveAUnit.add(suggestUnitMovementOptionsToPlayer);
		EventBus.playerWantsTo_moveUnitAtSelectedLocation.add(suggestMovementOptionsFromSelectedLocation);
		EventBus.playerWantsTo_cancelTheCurrentAction.add(cancelMovement);
		
		EventBus.mapMarkerPlacedOnMap.add(updateMovementAvailability);
		EventBus.mapMarkerRemovedFromMap.add(disableMovementButton);
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
		EventBus.displayNewStatusMessage.dispatch("Choose a unit or base to move.");
	}
	
	function suggestMovementOptionsFromSelectedLocation(?model):Void
	{
		// TODO:
		// highlight valid, adjacent movement tiles
	}
	
	function cancelMovement(?model)
	{
		this.activeMovementCard = null;
		this.markedHex = null;
		
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
	}
	
	function updateMovementAvailability(marker:HexTile):Void
	{
		this.markedHex = marker;
		if (activeMovementCard == null)
		{
			return;
		}
		
		// check that a player owned base exists in a neighbouring tile
		if (markedHex != null)
		{
			var location:HexTile = markedHex.map.getHexTile(markedHex.q, markedHex.r);
			if (location.containsUnit(Index.activeGame.activePlayer))
			{
				// Rule: players can only move their own units
				movement.moveButton.enable();
				return;
			}
		}
		
		movement.moveButton.disable();
	}
	
	function disableMovementButton(?marker:HexTile):Void
	{
		this.markedHex = null;
		
		movement.moveButton.disable();
	}
}