package net.mkv25.game.controllers;

import haxe.ds.StringMap;
import net.mkv25.game.event.EventBus;
import net.mkv25.game.models.CombatModel;
import net.mkv25.game.models.HexTile;
import net.mkv25.game.models.MapUnit;
import net.mkv25.game.models.MovementModel;
import net.mkv25.game.models.PlayableCard;
import net.mkv25.game.models.PlayerModel;
import net.mkv25.game.models.SelectedUnitModel;
import net.mkv25.game.provider.UnitProvider;
import net.mkv25.game.ui.DeploymentUI;
import net.mkv25.game.ui.MapUI;
import net.mkv25.game.ui.MovementUI;

class MoveUnitController
{
	private var map:MapUI;
	private var movement:MovementUI;
	
	private var selectedUnit:SelectedUnitModel;
	
	private var activeMovementCard:PlayableCard;
	private var markedLocation:HexTile;
	private var selectedLocation:HexTile;
	
	private var movementDestinations:StringMap<HexTile>;
	
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
		
		this.selectedUnit = new SelectedUnitModel();
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
		
		var previousSelectedUnit:MapUnit = selectedUnit.value;
		selectedLocation = markedLocation.map.getHexTile(markedLocation.q, markedLocation.r);
		var unit:MapUnit = selectUnitForPlayerFrom(selectedLocation, Index.activeGame.activePlayer);
		
		if (unit != null) 
		{
			if (unit.engagedInCombatThisTurn)
			{
				EventBus.displayNewStatusMessage.dispatch("Unit engaged in combat this turn");
				selectedUnit.value = null;
				map.disableMovementOverlay();
			}
			else if (unit.movedThisTurn)
			{
				EventBus.displayNewStatusMessage.dispatch("Unit has already moved this turn");
				selectedUnit.value = null;
				map.disableMovementOverlay();
			}
			else
			{
				selectedUnit.value = unit;
				
				movementDestinations = MovementModel.getValidMovementDestinationsFor(selectedLocation, selectedUnit.value, activeMovementCard.movement);
				map.enableMovementOverlayFor(movementDestinations, unit);
				
				if (previousSelectedUnit == null)
				{
					EventBus.displayNewStatusMessage.dispatch("Select a location to move to");
				}
				else if (previousSelectedUnit == unit)
				{
					EventBus.displayNewStatusMessage.dispatch(unit.type.name + " selected again");
				}
				else
				{
					EventBus.displayNewStatusMessage.dispatch(unit.type.name + " selected");
				}
				
				updateMovementConfirmationButton();
			}
		}
		else
		{
			EventBus.displayNewStatusMessage.dispatch("Choose a unit or base to move");
		}
	}
	
	function selectUnitForPlayerFrom(hex:HexTile, player:PlayerModel):Null<MapUnit>
	{
		var units = hex.listUnits();
		
		return units.getCandidateForMovement(player, selectedUnit.value);
	}
	
	function cancelMovement(?model)
	{
		this.activeMovementCard = null;
		this.selectedLocation = null;
		this.selectedUnit.value = null;
		
		disableMovement();
	}
	
	function enableMovement()
	{
		movement.enable();
		movement.show();
	}
	
	function disableMovement()
	{
		this.activeMovementCard = null;
		this.selectedUnit.value = null;
		
		movement.disable();
		movement.hide();
		
		map.disableMovementOverlay();
	}
	
	function updateMovementAvailability(marker:HexTile):Void
	{
		this.markedLocation = marker;
		if (activeMovementCard == null)
		{
			movement.selectUnitButton.disable();
			movement.confirmButton.disable();
			return;
		}
		
		updateMovementConfirmationButton();
		updateUnitSelectionButton();
	}
	
	function updateUnitSelectionButton():Void
	{
		// check that a player owned base exists in a neighbouring tile
		if (markedLocation != null)
		{
			var location:HexTile = markedLocation.map.getHexTile(markedLocation.q, markedLocation.r);
			if (location.containsUnit(Index.activeGame.activePlayer))
			{
				// Rule: players can only move their own units
				movement.selectUnitButton.enable();
				
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
		
		movement.selectUnitButton.disable();
	}
	
	function updateMovementConfirmationButton():Void
	{
		if (activeMovementCard == null)
		{
			return;
		}
		
		// check that marked location is a valid movement tile
		if (markedLocation != null && selectedLocation != null && selectedUnit.value != null)
		{
			if (MovementModel.mapContainsLocation(movementDestinations, markedLocation))
			{
				movement.confirmButton.enable();
				EventBus.displayNewStatusMessage.dispatch("Confirm movement");
				return;
			}
		}
		
		movement.confirmButton.disable();
		
		if (selectedUnit.value == null)
		{
			EventBus.displayNewStatusMessage.dispatch("No unit here");
		}
		else
		{
			EventBus.displayNewStatusMessage.dispatch("Cannot move to this location");
		}
	}
	
	function attemptToMoveUnitToSelectedLocation(?model):Void
	{
		// check that all the correct data is present at this point
		if (activeMovementCard == null || selectedLocation == null || selectedUnit == null || markedLocation == null)
		{
			movement.selectUnitButton.disable();
			movement.confirmButton.disable();
			return;
		}
		
		// check that unit can be moved
		if (selectedUnit.value.movedThisTurn || selectedUnit.value.engagedInCombatThisTurn)
		{
			movement.confirmButton.disable();
			return;
		}
		
		// get list of valid locations
		var destinations = MovementModel.getValidMovementDestinationsFor(selectedLocation, selectedUnit.value, activeMovementCard.movement);
		for (destination in destinations)
		{
			// validate that marked location is in the list of valid destination
			if (destination.equals(markedLocation))
			{
				var targetLocation = markedLocation.map.getHexTile(markedLocation.q, markedLocation.r);
				
				EventBus.removeCardFromActivePlayersHand.dispatch(activeMovementCard);
				CombatModel.moveUnit(selectedUnit.value, selectedLocation, targetLocation);
				cancelMovement();
				return;
			}
		}
	}
}