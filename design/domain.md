game : Game

-- units : Unit[]
   -- type : Pointer<Card>
   -- location : MapLocation
      -- map : Pointer<Map>
      -- q : Int
      -- r : Int

   -- owner : Pointer<Player>

-- map : GameMap
   -- seed : MapSeed
	  -- variant : Pointer<IStartVariant>
	  -- value : Int
	  
   -- space : SpaceMap
      -- mapId : String
         -- hexes : MapHex[]
            -- location : MapLocation
	            -- map : Pointer<Map>
	            -- q : Int
	            -- r : Int

   -- worlds : WorldMap[]
         -- mapId : String
         -- space location : MapLocation
            -- map : Pointer<Map>
            -- q : Int
            -- r : Int

         -- hexes : MapHex[]
            -- location : MapLocation
	            -- map : Pointer<Map>
	            -- q : Int
	            -- r : Int

-- players : Player[]
   -- playerId : String
   -- cards : PlayerHand
      -- deck : Pointer<Card>[]
      -- hand : Pointer<Card>[]
      -- discards : Pointer<Card>[]
   -- resources : Int

-- turn model : TurnModel
   -- active players : Pointer<Player>[]
   -- current player : Pointer<Player>

-- cards : Card[]
   -- cardId : String
   -- name : String
   -- action : String
   -- movement : Int
   -- resources : Int
   -- cost : Int
   -- picture tile : Int
