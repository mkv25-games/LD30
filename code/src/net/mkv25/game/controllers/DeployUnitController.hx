package net.mkv25.game.controllers;

import net.mkv25.game.event.EventBus;
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
	private var markedHex:HexTile;
	
	public function new()
	{
		EventBus.playerWantsTo_deployAUnitOnPlanet.add(suggestUnitPlanetDeploymentOptionsToPlayer);
		EventBus.playerWantsTo_deployAUnitInSpace.add(suggestUnitSpaceDeploymentOptionsToPlayer);
		EventBus.playerWantsTo_deployUnitAtSelectedLocation.add(attemptToPlaceUnitAtSelectedLocation);
		EventBus.playerWantsTo_cancelTheCurrentAction.add(cancelDeployment);
		
		EventBus.mapMarkerPlacedOnMap.add(updateDeploymentAvailability);
		EventBus.mapMarkerRemovedFromMap.add(disableDeploymentButton);
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
		EventBus.displayNewStatusMessage.dispatch("Choose a planet to deploy to.");
	}
	
	function suggestUnitSpaceDeploymentOptionsToPlayer(card:PlayableCard):Void
	{
		this.activeUnitCard = card;
		
		enableDeployment();
		EventBus.displayNewStatusMessage.dispatch("Choose a location to deploy to.");
	}
	
	function attemptToPlaceUnitAtSelectedLocation(?model):Void
	{
		// TODO:
		// validate active card is a unit
		// validate location for placement
		// place unit
		// move card to discard pile
		// disable deployment
		// status update
		
		var player:PlayerModel = Index.activeGame.activePlayer;
		
		if (markedHex != null)
		{
			var location:HexTile = markedHex.map.getHexTile(markedHex.q, markedHex.r);
			var unit:MapUnit = UnitProvider.getUnit(player, activeUnitCard);
			location.add(unit);
			
			EventBus.mapRequiresRedraw.dispatch(this);
			
			EventBus.trashCardFromActivePlayersHand.dispatch(activeUnitCard);
			
			disableDeployment();
		}
		else
		{
			cancelDeployment();
		}
	}
	
	function cancelDeployment(?model)
	{
		this.activeUnitCard = null;
		this.markedHex = null;
		
		disableDeployment();
	}
	
	function enableDeployment()
	{
		deployment.enable();
		deployment.show();
	}
	
	function disableDeployment()
	{
		deployment.disable();
		deployment.hide();
	}
	
	function updateDeploymentAvailability(marker:HexTile):Void
	{
		this.markedHex = marker;
		if (activeUnitCard == null)
		{
			return;
		}
		
		// inspect marked location
		var location:HexTile = markedHex.map.getHexTile(markedHex.q, markedHex.r);
		if (activeUnitCard.base && location.containsBase())
		{
			// Rule: bases cannot exist in the same hex
			deployment.deployButton.disable();
			return;
		}
		
		// check that a player owned base exists in a neighbouring tile
		var neighbours = location.getNeighbours();
		for (hex in neighbours)
		{
			if (hex.containsBase(Index.activeGame.activePlayer))
			{
				// Rule: units can only be deployed in player owned territory
				deployment.deployButton.enable();
				return;
			}
		}
		
		deployment.deployButton.disable();
	}
	
	function disableDeploymentButton(?marker:HexTile):Void
	{
		this.markedHex = null;
		
		deployment.deployButton.disable();
	}
}