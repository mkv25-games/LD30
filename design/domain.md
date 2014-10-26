game : Game

-- units : Unit[]
   -- type : CardId
   -- location : MapLocation
      -- map : MapId
      -- q : Int
      -- r : Int

   -- owner : Player

-- map
   -- seed : MapSeed
      -- type : MapType

   -- space : SpaceMap
      -- id : MapId
      -- hexes : MapLocation[]
         -- map : MapId
         -- q : Int
         -- r : Int

   -- worlds : WorldMap[]
         -- id : MapId
         -- space location : MapLocation
            -- map : MapId
            -- q : Int
            -- r : Int

         -- hexes[] : MapHex
            -- location : MapLocation
	            -- map : MapId
	            -- q : Int
	            -- r : Int

-- players[] : Player
   -- playerId : PlayerId
   -- cards : PlayerHand
      -- deck[] : CardId
      -- hand[] : CardId
      -- discards[] : CardId

-- turn model[]
   -- active players : PlayerId[]
   -- current player : PlayerId[]

-- cards : Card[]
   -- cardId : CardId
   -- name : String
   -- action : String
   -- movement : Int
   -- resources : Int
   -- cost : Int
   -- picture tile : Int
