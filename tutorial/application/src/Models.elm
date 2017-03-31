
module Models exposing (..)

import RemoteData exposing ( WebData )

type alias Model = {
        players : WebData ( List Player )
    ,   route : Route
    ,   err : String
    }
-- type alias Model = { players : List Player }

type alias PlayerId = String

type alias Player = {
        id : PlayerId
    ,   name : String
    ,   level : Int
    ,   equip : String
    }

type Route =
      PlayersRoute
    | PlayerRoute PlayerId
    | NotFoundRoute

initialModel : Route -> Model
initialModel route = {
        players = RemoteData.Loading
    ,   route = route
    ,   err = "Unchanged"
    }
-- initialModel = { players = [ Player "1" "Sam" 1 ] }

type Method = Patch | Post | Delete


