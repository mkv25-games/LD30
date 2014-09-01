package net.mkv25.game.controllers;

import net.mkv25.game.event.EventBus;
import net.mkv25.game.models.MapModel;
import net.mkv25.game.models.MapUnit;
import net.mkv25.game.models.PlayerModel;
import net.mkv25.game.ui.MapUI;

class MapFocusController
{
	var mapHud:MapUI;

	public function new() 
	{
		
	}
	
	public function setup(mapHud:MapUI):Void
	{
		this.mapHud = mapHud;
		
		EventBus.activePlayerChanged.add(focusMapToPlayer);
	}
	
	function focusMapToPlayer(player:PlayerModel):Void
	{
		var map:MapModel = null;
		var unit:MapUnit = null;
		
		if (player == null)
		{
			return;
		}
		
		if (player.baseCount() > 0)
		{
			unit = player.bases.getHighestStrengthUnit();
		}
		else if (player.unitCount() > 0)
		{
			unit = player.units.getHighestStrengthUnit();
		}
		
		map = unit.lastKnownLocation.map;
		map = (map == null) ? Index.activeGame.space : map;
		
		this.mapHud.setupMap(map);
	}
	
}