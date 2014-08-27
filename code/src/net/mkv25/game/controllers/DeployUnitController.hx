package net.mkv25.game.controllers;
import net.mkv25.game.event.EventBus;
import net.mkv25.game.models.PlayableCard;
import net.mkv25.game.ui.DeploymentUI;
import net.mkv25.game.ui.MapUI;

class DeployUnitController
{
	private var map:MapUI;
	private var deployment:DeploymentUI;
	
	public function new()
	{
		EventBus.playerWantsTo_deployAUnitOnPlanet.add(suggestUnitPlanetDeploymentOptionsToPlayer);
		EventBus.playerWantsTo_deployAUnitInSpace.add(suggestUnitSpaceDeploymentOptionsToPlayer);
	}
	
	public function setup(map:MapUI, deployment:DeploymentUI):Void
	{
		this.map = map;
		this.deployment = deployment;
	}
	
	function suggestUnitPlanetDeploymentOptionsToPlayer(card:PlayableCard):Void
	{
		enableDeployment();
	}
	
	function suggestUnitSpaceDeploymentOptionsToPlayer(card:PlayableCard):Void
	{
		enableDeployment();
	}
	
	function enableDeployment()
	{
		deployment.enable();
		deployment.show();
	}
	
	function endDeployment()
	{
		deployment.disable();
		deployment.hide();
	}
}