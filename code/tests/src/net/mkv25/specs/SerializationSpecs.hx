package net.mkv25.specs;

import haxe.Json;
import hxpect.core.BaseSpec;
import net.mkv25.game.models.game.Card;
import net.mkv25.game.models.game.Game;
import net.mkv25.game.models.game.GameMap;
import net.mkv25.game.models.game.Player;
import net.mkv25.game.models.game.Unit;

class SerializationSpecs extends BaseSpec
{
	public var emptyGameData(get, null):Dynamic;
	
	function get_emptyGameData():Dynamic
	{
		var emptyGameData:Dynamic = {
			cards: [],
			map: {
				archetype: {
					seed: 0
				},
				space: {
					hexes: []
				},
				worlds: []
			},
			players: [],
			units: []
		};
		
		return emptyGameData;
	}
	
	function verify(domain:Game):Void
	{
		var verification = new Game();
		
		var domainData = Json.stringify(domain);
		verification.readFrom(domainData);
		
		var expected = domainData;
		var actual = Json.stringify(verification);
		
		expect(actual).to.be(expected);
	}
	
	override public function run()
	{
		var domain:Game;
		
		beforeEach(function()
		{
			domain = new Game();
		});
		
		describe("Serializing empty data", function()
		{
			it("should be able to serialize, and deserialize an empty game object", function()
			{
				var expected = emptyGameData;
				
				var result = domain.serialize();
				
				expect(Json.stringify(result)).to.be(Json.stringify(expected));
				
				verify(domain);
			});
		});
		
		describe("Serializing cards", function()
		{
			var card:Card;
			var cardData:Dynamic = {
				action: "expected action",
				cardId: "expected card id",
				cost: 10,
				movement: 20,
				name: "expected card name",
				pictureTile: 30
			};
			
			beforeEach(function()
			{
				card = new Card();
				card.readFrom(cardData);
			});
			
			it("should be able to serialize, and deserialize cards", function()
			{
				domain.cards.push(card);
				
				var expected = emptyGameData;
				expected.cards.push(cardData);
				
				var result = domain.serialize();
				
				expect(Json.stringify(result)).to.be(Json.stringify(expected));
				
				verify(domain);
			});
		});
		
		describe("Serializing units", function()
		{
			var unit:Unit;
			var unitData:Dynamic = {
				type: "expected unit id",
				owner: "expected owner id",
				location: {
					map: "expected map id",
					q: 200,
					r: 300
				}
			};
			
			beforeEach(function()
			{
				unit = new Unit();
				unit.readFrom(unitData);
			});
			
			it("should be able to serialize, and deserialize units", function()
			{
				domain.units.push(unit);
				
				var expected = emptyGameData;
				expected.units.push(unitData);
				
				var result = domain.serialize();
				
				expect(Json.stringify(result)).to.be(Json.stringify(expected));
				
				verify(domain);
			});
		});
		
		describe("Serializing players", function()
		{
			var player:Player;
			var playerData:Dynamic = {
				playerId: "expected player id",
				cards: {
					deck: ["card one", "card two"],
					hand: ["card three", "card four"],
					discards: ["card five", "card six", "card seven"]
				},
				resources: 500
			};
			
			beforeEach(function()
			{
				player = new Player();
				player.readFrom(playerData);
			});
			
			it("should be able to serialize, and deserialize players", function()
			{
				domain.players.push(player);
				
				var expected = emptyGameData;
				expected.players.push(playerData);
				
				var result = domain.serialize();
				
				expect(Json.stringify(result)).to.be(Json.stringify(expected));
				
				verify(domain);
			});
		});
		
		describe("Serializing the game map", function()
		{
			var map:GameMap;
			var mapData:Dynamic = {
				archetype: {
					variant: "expected variant id",
					seed: 500
				},
				space: {
					mapId: "s",
					hexes: [
						{q: 4, r: 4, map: "s" }
					]
				},
				worlds: [
					{
						mapId: "w1",
						hexes: [
							{q: 5, r: 5, map: "w1" }
						]
					}
				]
			};
			
			beforeEach(function()
			{
				domain.map.readFrom(mapData);
			});
			
			it("should be able to serialize, and deserialize the game map", function()
			{
				var expected = emptyGameData;
				expected.map = mapData;
				
				var result = domain.serialize();
				
				expect(Json.stringify(result)).to.be(Json.stringify(expected));
				
				verify(domain);
			});
		});
	}	
}