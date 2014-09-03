package net.mkv25.game.controllers;

import net.mkv25.game.event.EventBus;
import net.mkv25.game.models.CombatModel;
import net.mkv25.game.models.HexTile;
import net.mkv25.game.models.MapUnit;
import net.mkv25.game.models.MovementModel;
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
	private var selectedUnit:MapUnit;
	
	public function new()
	{
		EventBus.playerWantsTo_moveAUnit.add(suggestUnitMovementOptionsToPlayer);
		EventBus.playerWantsTo_moveUnitAtSelectedLocation.add(attemptToSelectUnitAndSuggestMovementOptions);
		EventBus.playerWantsTo_confirmTheSelectedMovementAction.add(attemptToMoveUnitToSelectedLocation);
		
		EventBus.playerWantsTo_cancelTheCurrentAction.add(cancelMovement);
		EventBus.cardSelectedFromHandByPlayer.add(cancelMovement);
		
		EventBus.mapMarkerPlacedOnMap.add(updateMovementAvailability);
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
		
		attemptToSelectUnitAndSuggestMovementOptions();
	}
	
	function attemptToSelectUnitAndSuggestMovementOptions(?model):Void
	{
		// highlight valid, adjacent movement tiles
		if (markedLocation == null)
		{
			return;
		}
		
		selectedLocation = markedLocation.map.getHexTile(markedLocation.q, markedLocation.r);
		selectedUnit = selectUnitForPlayerFrom(selectedLocation, Index.activeGame.activePlayer);
		if (selectedUnit != null) 
		{
			map.enableMovementOverlayFor(selectedLocation, selectedUnit, activeMovementCard.movement);
			updateMovementConfirmation();
			EventBus.displayNewStatusMessage.dispatch("Select a tile to move to");
		}
		else
		{
			EventBus.displayNewStatusMessage.dispatch("Choose a unit or base to move");
		}
	}
	
	function selectUnitForPlayerFrom(hex:HexTile, player:PlayerModel):Null<MapUnit>
	{
		var units = hex.listUnits();
		
		return units.getHighestStrengthUnit(player);
	}
	
	function cancelMovement(?model)
	{
		this.activeMovementCard = null;
		this.selectedLocation = null;
		this.selectedUnit = null;
		
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
		
		updateMovementConfirmation();
		updateMovementSelection();
	}
	
	function updateMovementSelection():Void
	{
		// check that a player owned base exists in a neighbouring tile
		if (markedLocation != null)
		{
			var location:HexTile = markedLocation.map.getHexTile(markedLocation.q, markedLocation.r);
			if (location.containsUnit(Index.activeGame.activePlayer))
			{
				// Rule: players can only move their own units
				movement.moveButton.enable();
				
				// report to player about selection
				var unit:MapUnit = selectUnitForPlayerFrom(location, Index.activeGame.activePlayer);
				if (selectedUnit != null)
				{
					EventBus.displayNewStatusMessage.dispatch("Change selection: " + unit.type.name);
				}
				else
				{
					EventBus.displayNewStatusMessage.dispatch("Confirm selection: " + unit.type.name);
				}
				
				return;
			}
		}
		
		movement.moveButton.disable();
	}
	
	function updateMovementConfirmation():Void
	{
		// check that marked location is a valid movement tile
		if (markedLocation != null && selectedLocation != null && selectedUnit != null)
		{
			var destinations = MovementModel.getValidMovementDestinationsFor(selectedLocation, selectedUnit, activeMovementCard.movement);
			if (MovementModel.mapContainsLocation(destinations, markedLocation))
			{
				movement.confirmButton.enable();
				EventBus.displayNewStatusMessage.dispatch("Confirm movement");
				return;
			}
		}
		
		movement.confirmButton.disable();
		
		if (selectedUnit == null)
		{
			EventBus.displayNewStatusMessage.dispatch("No unit here");
		}
		else if(activeMovementCard != null)
		{
			EventBus.displayNewStatusMessage.dispatch("Cannot move more than " + activeMovementCard.movement + " distance");
		}
	}
	
	function attemptToMoveUnitToSelectedLocation(?model):Void
	{
		// check that all the correct data is present at this point
		if (activeMovementCard == null || selectedLocation == null || selectedUnit == null || markedLocation == null)
		{
			movement.moveButton.disable();
			movement.confirmButton.disable();
			return;
		}
		
		// get list of valid locations
		var destinations = MovementModel.getValidMovementDestinationsFor(selectedLocation, selectedUnit, activeMovementCard.movement);
		for (destination in destinations)
		{
			// validate that marked location is in the list of valid destination
			if (destination.equals(markedLocation))
			{
				var targetLocation = markedLocation.map.getHexTile(markedLocation.q, markedLocation.r);
				
				EventBus.removeCardFromActivePlayersHand.dispatch(activeMovementCard);
				CombatModel.moveUnit(selectedUnit, selectedLocation, targetLocation);
				cancelMovement();
				return;
			}
		}
	}
}