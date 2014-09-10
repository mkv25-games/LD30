package net.mkv25.game.models;

class ResourceTransactionModel
{
	public var playerResources:Int;
	public var resourceChange:Int;

	public function new(player:PlayerModel, resourceChange:Int) 
	{
		this.playerResources = player.resources;
		this.resourceChange = resourceChange;
	}
}