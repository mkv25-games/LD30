package net.mkv25.game.controllers;

import net.mkv25.game.enums.PlayableCardType;
import net.mkv25.game.event.EventBus;
import net.mkv25.game.models.CombatModel;
import net.mkv25.game.models.HexTile;
import net.mkv25.game.models.MapUnit;
import net.mkv25.game.models.PlayableCard;
import net.mkv25.game.models.PlayerModel;
import net.mkv25.game.provider.UnitProvider;
import net.mkv25.game.ui.DeploymentUI;
import net.mkv25.game.ui.MapUI;

class DeployUnitController
{
	private var map:MapUI;
	private var deployment:DeploymentUI;
	
	private var activeUnitCard:PlayableCard;
	private var markedLocation:HexTile;
	
	public function new()
	{
		EventBus.playerWantsTo_deployAUnit.add(suggestUnitPlanetDeploymentOptionsToPlayer);
		EventBus.playerWantsTo_deployUnitAtSelectedLocation.add(attemptToPlaceUnitAtSelectedLocation);
		
		EventBus.playerWantsTo_cancelTheCurrentAction.add(cancelDeployment);
		EventBus.cardSelectedFromHandByPlayer.add(cancelDeployment);
		
		EventBus.mapMarkerPlacedOnMap.add(updateDeploymentAvailability);
	}
	
	public function setup(map:MapUI, deployment:DeploymentUI):Void
	{
		this.map = map;
		this.deployment = deployment;
	}
	
	function suggestUnitPlanetDeploymentOptionsToPlayer(card:PlayableCard):Void
	{
		this.activeUnitCard = card;
		
		enableDeployment();
		EventBus.displayNewStatusMessage.dispatch("Choose a location to deploy to");
		
		// attempt deployment immediately
		attemptToPlaceUnitAtSelectedLocation();
	}
	
	function attemptToPlaceUnitAtSelectedLocation(?model):Void
	{
		// Checklist:
		// + validate active card is a unit
		// + validate location for placement
		// + place unit
		// + status update
		// + move card to discard pile
		// + disable deployment
		
		if (activeUnitCard == null || activeUnitCard.deployable == false)
		{
			return;
		}
		
		var player:PlayerModel = Index.activeGame.activePlayer;
		
		if (checkIfPlayerCanDeployUnitToLocation(player, activeUnitCard, markedLocation))
		{
			var location:HexTile = markedLocation.map.getHexTile(markedLocation.q, markedLocation.r);
			var unit:MapUnit = UnitProvider.getUnit(player, activeUnitCard);
			location.add(unit);
			
			// Rule: When a 
			EventBus.trashCardFromActivePlayersHand.dispatch(activeUnitCard);
			
			disableDeployment();
			
			CombatModel.moveUnit(unit, location, location);
			
			// Rule: Units that have just been deployed can be moved on the same turn
			unit.resetFlags();
			
			EventBus.displayNewStatusMessage.dispatch(unit.type.name + " deployed");
		}
	}
	
	function cancelDeployment(?model)
	{
		disableDeployment();
	}
	
	function enableDeployment()
	{
		deployment.enable();
		deployment.show();
		
		updateDeploymentAvailability();
	}
	
	function disableDeployment()
	{
		this.activeUnitCard = null;
		
		deployment.disable();
		deployment.hide();
	}
	
	function updateDeploymentAvailability(?marker:HexTile):Void
	{
		if (marker != null)
		{
			this.markedLocation = marker;
		}
		
		if (activeUnitCard == null)
		{
			return;
		}
		
		if (checkIfPlayerCanDeployUnitToLocation(Index.activeGame.activePlayer, activeUnitCard, markedLocation))
		{
			deployment.deployButton.enable();
		}
		else
		{
			deployment.deployButton.disable();
		}
	}
	
	function checkIfPlayerCanDeployUnitToLocation(player:PlayerModel, unitType:PlayableCard, location:HexTile):Bool
	{
		if (player == null || unitType == null || location == null)
		{
			return false;
		}
		
		location = location.map.getHexTile(location.q, location.r);
		
		if (location.containsBase() && unitType.base)
		{
			// Rule: bases cannot exist in the same hex
			EventBus.displayNewStatusMessage.dispatch("Bases cannot exist in the same hex");
			return false;
		}
		
		if(location.containsBase(player) && !unitType.base)
		{
			// Rule: non-base units can be deployed in same hex as a base
			EventBus.displayNewStatusMessage.dispatch("Confirm deployment");
			return true;
		}
		
		// On worlds only, check that a player owned base exists in a neighbouring tile
		if (location.map.isWorld())
		{
			var neighbours = location.getNeighbours();
			for (hex in neighbours)
			{
				if (hex.containsBase(player))
				{
					// Rule: units can only be deployed in player owned territory
					EventBus.displayNewStatusMessage.dispatch("Confirm deployment");
					return true;
				}
			}
		}
		
		// Provide advice to the user
		if (location.territoryOwner == null)
		{
			EventBus.displayNewStatusMessage.dispatch("Cannot deploy outside your territory");
		}
		else if (location.territoryOwner != Index.activeGame.activePlayer)
		{
			EventBus.displayNewStatusMessage.dispatch("Cannot deploy in enemy territory");
		}
		
		return false;
	}
}