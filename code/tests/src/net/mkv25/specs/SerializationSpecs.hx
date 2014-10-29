package net.mkv25.specs;

import haxe.Json;
import hxpect.core.BaseSpec;
import net.mkv25.game.models.game.Card;
import net.mkv25.game.models.game.Game;
import net.mkv25.game.models.game.Unit;

class SerializationSpecs extends BaseSpec
{
	override public function run()
	{
		var domain:Game;
		
		beforeEach(function()
		{
			domain = new Game();
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
				
				var expected = {
					cards: [cardData],
					units: []
				}
				var result = domain.serialize();
				
				expect(Json.stringify(result)).to.be(Json.stringify(expected));
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
				
				var expected = {
					cards: [],
					units: [unitData]
				}
				var result = domain.serialize();
				
				expect(Json.stringify(result)).to.be(Json.stringify(expected));
			});
		});
	}	
}