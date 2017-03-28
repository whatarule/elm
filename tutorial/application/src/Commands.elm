
module Commands exposing (..)

import Http
import Json.Decode as Decode
import Json.Decode.Pipeline exposing ( decode, required )
import Msgs exposing ( Msg )
import Models exposing ( Model, Player, PlayerId )
import RemoteData
import Html exposing ( Attribute )
import Html.Events exposing ( onWithOptions )
import Json.Encode as Encode
--import List

fetchPlayers : Cmd Msg
fetchPlayers =
      Http.get fetchPlayersUrl playersDecoder
  |>  RemoteData.sendRequest
  |>  Cmd.map Msgs.OnFetchPlayers

fetchPlayersUrl : String
fetchPlayersUrl = "http://localhost:4000/players"

playersDecoder : Decode.Decoder ( List Player )
playersDecoder = Decode.list playerDecoder

playerDecoder : Decode.Decoder Player
playerDecoder =
      decode Player
  |>  required "id" Decode.string
  |>  required "name" Decode.string
  |>  required "level" Decode.int


onLinkClick : msg -> Attribute msg
onLinkClick message =
  let options = {
          stopPropagation = False
      ,   preventDefault = True
      }
  in onWithOptions "click" options ( Decode.succeed message )


savePlayersUrl : String
savePlayersUrl =
    "http://localhost:4000/players/"

savePlayerUrl : PlayerId -> String
savePlayerUrl playerId =
    "http://localhost:4000/players/" ++ playerId


type Method = Patch | Post | Delete

-- // Player
savePlayerRequest : Method -> Player -> Http.Request Player
savePlayerRequest method player =
  let ( methodStr, urlId ) = case method of
        Patch-> ( "PATCH", player.id )
        Post -> ( "POST", "" )
        Delete -> ( "DELETE", player.id )
  in Http.request {
        body = player
          |>  playerEncoder
          |>  Http.jsonBody
    ,   expect = Http.expectJson playerDecoder
    ,   headers = [ ]
--  ,   method = "PATCH"
    ,   method = methodStr
    ,   timeout = Nothing
    ,   url = savePlayerUrl urlId
    ,   withCredentials = False
    }

savePlayerCmd : Method -> Player -> Cmd Msg
savePlayerCmd method player = player
  |>  savePlayerRequest method
  |>  Http.send Msgs.OnPlayerSave

playerEncoder : Player -> Encode.Value
playerEncoder player =
  let attributes = [
          ( "id", Encode.string player.id )
      ,   ( "name", Encode.string player.name )
      ,   ( "level", Encode.int player.level )
      ]
  in Encode.object attributes


savePlayersCmd : Model -> Method -> Player -> Cmd Msg
savePlayersCmd model method player = player
  |>  savePlayerRequest method
  |>  Http.send Msgs.OnPlayerSave


-- // List Player
--savePlayersCmd : List Player -> Cmd Msg
--savePlayersCmd players = players
--  |>  savePlayersRequest
--  |>  Http.send Msgs.OnPlayersSave
----|>  Http.send Msgs.OnPlayerSave
--
--savePlayersRequest : List Player -> Http.Request ( List Player )
----savePlayersRequest : List Player -> Http.Request Player
--savePlayersRequest players =
--    Http.request {
--        body = players
--          |>  playersEncoder
--          |>  Http.jsonBody
--    ,   expect = Http.expectJson playersDecoder
----  ,   expect = Http.expectJson playerDecoder
--    ,   headers = [ ]
----  ,   method = "PATCH"
----  ,   method = "POST"
--    ,   method = "PUT"
--    ,   timeout = Nothing
--    ,   url = "http://localhost:4000/players"
----  ,   url = savePlayersUrl
----  ,   url = savePlayersUrl ++ "7"
--    ,   withCredentials = False
--    }
--
--playersEncoder : List Player -> Encode.Value
--playersEncoder players =
--      List.map playerEncoder players
--  |>  Encode.list
----    playerEncoder testPlayer
--
--
--testPlayer : Player
--testPlayer = {
--        id = "7"
--    ,   name = "test"
--    ,   level = 1
--    }


