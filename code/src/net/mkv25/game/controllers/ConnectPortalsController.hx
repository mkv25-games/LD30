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
	
	private var activePortalCard:PlayableCard;
	private var markedLocation:HexTile;
	
	private var baseStart:MapUnit;
	private var baseEnd:MapUnit;
	
	public function new()
	{
		EventBus.playerWantsTo_connectBasesWithPortals.add(suggestPortalConnectionOptionsToPlayer);
		EventBus.playerWantsTo_connectBaseAtSelectedLocation.add(attemptToConnectPortalAtSelectedLocation);
		EventBus.playerWantsTo_openThePortal.add(openThePortal);
		
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
		this.activePortalCard = card;
		
		enableConnections();
		EventBus.displayNewStatusMessage.dispatch("Choose two bases to connect");
		
		attemptToConnectPortalAtSelectedLocation();
	}
	
	function attemptToConnectPortalAtSelectedLocation(?model):Void
	{
		var baseSelected:Bool = false;
		
		// TODO:
		// Checklist:
		// + validate active card is a unit
		// + validate location contains connectable base
		// + record base for connection
		// + status update
		// + connect bases if second base is recorded
		// + disable connections
		
		if (activePortalCard != PlayableCardType.PORTAL)
		{
			return;
		}
		
		if (markedLocation == null)
		{
			return;
		}
		
		var location:HexTile = markedLocation.map.getHexTile(markedLocation.q, markedLocation.r);
		if (location == null)
		{
			return;
		}
		
		var baseAtLocation:MapUnit = location.getBase();
		if (baseAtLocation == null)
		{
			return;
		}
		
		if (baseStart == null)
		{
			baseStart = baseAtLocation;
			baseSelected = true;
		}
		else if (baseEnd == null
			&& baseStart != baseEnd
			&& !baseStart.isConnectedTo(baseAtLocation)
			&& !baseAtLocation.isConnectedTo(baseStart))
		{
			baseEnd = baseAtLocation;
		}
		
		checkConnectionAvailability();
		
		if (baseSelected)
		{
			EventBus.displayNewStatusMessage.dispatch("Base selected for connection");
		}
	}
	
	function openThePortal(?model):Void
	{
		// TODO:
		// + register connection between baseStart and baseEnd
		// + register connection between baseEnd and baseStart
		// + redraw map, with connections
		// + enable movement through connected bases
		
		if (baseStart == null || baseEnd == null || activePortalCard == null)
		{
			return;
		}
		
		baseStart.connectTo(baseEnd);
		baseEnd.connectTo(baseStart);
		
		EventBus.mapRequiresRedraw.dispatch(this);
		EventBus.removeCardFromActivePlayersHand.dispatch(activePortalCard);
		cancelConnection();
		
		EventBus.displayNewStatusMessage.dispatch("Portal opened");
	}
	
	function cancelConnection(?model)
	{
		this.activePortalCard = null;
		
		baseStart = null;
		baseEnd = null;
		
		portals.reset();
		
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
		
		if (activePortalCard == null)
		{
			return;
		}
		
		checkConnectionAvailability();
	}
	
	function checkConnectionAvailability():Void
	{
		if (markedLocation == null)
		{
			portals.reset();
			return;
		}
		
		// checks to activate the first portal button
		var location:HexTile = markedLocation.map.getHexTile(markedLocation.q, markedLocation.r);
		var containsPlayerBase:Bool = location.containsBase(Index.activeGame.activePlayer);
		var baseAtLocation = location.getBase();
			
		if (!containsPlayerBase)
		{
			EventBus.displayNewStatusMessage.dispatch("No base at location");
		}
		else if (baseStart == baseAtLocation)
		{
			EventBus.displayNewStatusMessage.dispatch("Base selected for connection");
		}
		
		if (baseStart == null && location != null && containsPlayerBase)
		{
			portals.portal1Button.enable();
			EventBus.displayNewStatusMessage.dispatch("Valid base, select?");
		}
		else
		{
			portals.portal1Button.disable();
		}
		
		// checks to activate the second portal location
		if (baseStart != null
			&& baseEnd == null
			&& containsPlayerBase
			&& baseStart != baseAtLocation)
		{
			if (baseStart.isConnectedTo(baseAtLocation) || baseAtLocation.isConnectedTo(baseStart))
			{
				EventBus.displayNewStatusMessage.dispatch("Selected bases are already connected");
				portals.portal2Button.disable();
			}
			else
			{
				portals.portal2Button.enable();
				EventBus.displayNewStatusMessage.dispatch("Valid base, select?");
			}
		}
		else
		{
			portals.portal2Button.disable();
		}
		
		// checks to activate the confirmation button
		if (baseStart != null
			&& baseEnd != null
			&& baseStart != baseEnd
			&& !baseStart.isConnectedTo(baseEnd)
			&& !baseEnd.isConnectedTo(baseStart))
		{
			portals.confirmButton.enable();
			EventBus.displayNewStatusMessage.dispatch("Valid connection, confirm?");
		}
		else
		{
			portals.confirmButton.disable();
		}
		
		// update icons
		portals.update(baseStart, baseEnd);
	}
}