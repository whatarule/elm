
module Routing exposing (..)

import Navigation exposing ( Location )
import Models exposing ( PlayerId, Route (..) )
import UrlParser exposing (..)


playersPath : String
playersPath = "/players"

playerPath : PlayerId -> String
playerPath id = playersPath ++ "/" ++ id

matchers : Parser ( Route -> a ) a
matchers  = oneOf [
        map PlayersRoute top
    ,   map PlayerRoute ( s "players" </> string )
    ,   map PlayersRoute ( s "players" )
    ]

parseLocation : Location -> Route
parseLocation location =
    case ( parsePath matchers location ) of
        Just route -> route
        Nothing -> NotFoundRoute
