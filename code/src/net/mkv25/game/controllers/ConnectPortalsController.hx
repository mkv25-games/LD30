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
import net.mkv25.game.ui.PortalsUI;

class ConnectPortalsController
{
	private var map:MapUI;
	private var portals:PortalsUI;
	
	private var activeUnitCard:PlayableCard;
	private var markedLocation:HexTile;
	
	private var base1:MapUnit;
	private var base2:MapUnit;
	
	public function new()
	{
		EventBus.playerWantsTo_connectBasesWithPortals.add(suggestPortalConnectionOptionsToPlayer);
		EventBus.playerWantsTo_connectBaseAtSelectedLocation.add(attemptToConnectPortalAtSelectedLocation);
		EventBus.playerWantsTo_openThePortal.add(attemptToConnectPortalAtSelectedLocation);
		
		EventBus.playerWantsTo_cancelTheCurrentAction.add(cancelConnection);
		EventBus.cardSelectedFromHandByPlayer.add(cancelConnection);
		
		EventBus.mapMarkerPlacedOnMap.add(updateConnectionAvailability);
	}
	
	public function setup(map:MapUI, portals:PortalsUI):Void
	{
		this.map = map;
		this.portals = portals;
	}
	
	function suggestPortalConnectionOptionsToPlayer(card:PlayableCard):Void
	{
		this.activeUnitCard = card;
		
		enableConnections();
		EventBus.displayNewStatusMessage.dispatch("Choose two bases to connect");
	}
	
	function attemptToConnectPortalAtSelectedLocation(?model):Void
	{
		// TODO:
		// Checklist:
		// + validate active card is a unit
		// + validate location contains connectable base
		// + record base for connection
		// + status update
		// + connect bases if second base is recorded
		// + disable connections
		
		if (activeUnitCard == null || activeUnitCard.deployable == false)
		{
			return;
		}
	}
	
	function cancelConnection(?model)
	{
		this.activeUnitCard = null;
		
		base1 = null;
		base2 = null;
		
		disableConnections();
	}
	
	function enableConnections()
	{
		portals.enable();
		portals.show();
		
		checkConnectionAvailability();
	}
	
	function disableConnections()
	{
		portals.disable();
		portals.hide();
	}
	
	function updateConnectionAvailability(?marker:HexTile):Void
	{
		if (marker != null)
		{
			this.markedLocation = marker;
		}
		
		checkConnectionAvailability();
	}
	
	function checkConnectionAvailability():Void
	{
		if (markedLocation == null)
		{
			portals.portal1Button.disable();
			portals.portal2Button.disable();
			portals.confirmButton.disable();
			return;
		}
		
		// checks to activate the first portal button
		var location:HexTile = markedLocation.map.getHexTile(markedLocation.q, markedLocation.r);
		
		if (base1 == null && location.containsBase(Index.activeGame.activePlayer))
		{
			portals.portal1Button.enable();
		}
		else
		{
			portals.portal1Button.disable();
		}
		
		// checks to activate the second portal location
		if (base1 != null
			&& base2 == null
			&& location.containsBase(Index.activeGame.activePlayer)
			&& base1 != base2)
		{
			if (!base1.isConnectedTo(base2) && !base2.isConnectedTo(base1))
			{
				EventBus.displayNewStatusMessage.dispatch("Selected bases are already connected");
				portals.portal2Button.disable();
			}
			else
			{
				portals.portal2Button.enable();
			}
		}
		else
		{
			portals.portal2Button.disable();
		}
		
		// checks to activate the confirmation button
		if (base1 != null
			&& base2 != null
			&& base1 != base2
			&& !base1.isConnectedTo(base2)
			&& !base2.isConnectedTo(base1))
		{
			portals.confirmButton.enable();
		}
		else
		{
			portals.confirmButton.disable();
		}
	}
}