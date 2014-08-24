package net.mkv25.game.models;

import flash.display.BitmapData;
import net.mkv25.base.core.CoreModel;

class PlayableCard extends CoreModel
{
	public var name:String;
	
	public var cost:Int;
	public var movement:Int;
	public var action:String;
	public var resources:Int;
	
	public var strength:Int;
	public var base:Bool;
	public var deployable:Bool;
	
	public var pictureTile:Int;
	public var picture:BitmapData;

	public var iconOffset:Int;
	
	public function new() 
	{
		super();
		
		name = "";
		
		cost = 0;
		movement = 0;
		action = "";
		resources = 0;
		
		strength = 0;
		base = false;
		deployable = false;
		
		pictureTile = -1;
		picture = null;
		
		iconOffset = -1;
	}
	
	public function setName(name:String):PlayableCard {
		this.name = name;
		
		return this;
	}
	
	public function setPicture(picture:BitmapData):PlayableCard
	{
		this.picture = picture;
		
		return this;
	}
	
	public static function createActionCardFrom(json:Dynamic):PlayableCard
	{
		var card = new PlayableCard();
		
		card.cost = card.readInt("cost", json, 1);
		card.pictureTile = card.readInt("pictureTile", json, -1);
		
		card.movement = card.readInt("movement", json, 1);
		card.action = card.read("action", json, "no action");
		card.resources = card.read("resources", json, 0);
		
		return card;
	}
	
	public static function createUnitCardFrom(json:Dynamic):PlayableCard
	{
		var card = new PlayableCard();
		
		card.cost = card.readInt("cost", json, 1);
		card.pictureTile = card.readInt("pictureTile", json, -1);
		card.iconOffset = card.readInt("iconOffset", json, 0);
		
		card.strength = card.readInt("strength", json, 1);
		card.base = card.readBool("base", json, false);
		card.deployable = true;
		
		return card;
	}
	
}