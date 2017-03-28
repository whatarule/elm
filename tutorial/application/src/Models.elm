
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
    }

type Route =
      PlayersRoute
    | PlayerRoute PlayerId
    | NotFoundRoute

initialModel : Route -> Model
initialModel route = {
        players = RemoteData.Loading
    ,   route = route
    ,   err = ""
    }
-- initialModel = { players = [ Player "1" "Sam" 1 ] }
