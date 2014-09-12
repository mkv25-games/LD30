package net.mkv25.game.models.startVariants;
import net.mkv25.game.models.MapModel;
import net.mkv25.game.models.PlayerModel;

interface IStartVariant
{
	public function startingCards():Array<PlayableCard>;
	public function startingUnitPlacement(player:PlayerModel, startingWorld:MapModel):Void;
	public function startingResources():Int;
}