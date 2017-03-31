
module Commands exposing (..)

import Http
import Json.Decode as Decode
import Json.Decode.Pipeline exposing ( decode, required )
import Msgs exposing ( Msg )
import Models exposing ( Model, Player, PlayerId, Method(..) )
import RemoteData
import RemoteData exposing ( WebData )
import Html exposing ( Attribute )
import Html.Events exposing ( onWithOptions )
import Json.Encode as Encode
import Navigation exposing ( newUrl )
import Routing exposing ( parseLocation, playerPath )
--import Guards exposing ( (|=), (=>) )

fetchPlayers : Cmd Msg
fetchPlayers =
      Http.get fetchPlayersUrl playersDecoder
  |>  RemoteData.sendRequest
  |>  Cmd.map Msgs.OnFetchPlayers

fetchPlayersUrl : String
fetchPlayersUrl =
    "http://localhost:4000/players"

checkNewPlayer : WebData ( List Player ) -> Cmd Msg
checkNewPlayer response = case response of
  RemoteData.NotAsked -> Cmd.none
  RemoteData.Loading -> Cmd.none
  RemoteData.Failure error -> Cmd.none
  RemoteData.Success players ->
    let maybePlayer = players
          |>  List.filter
                ( \ player -> player.name == "" )
          |>  List.head
    in case maybePlayer of
        Just player ->
          newUrl ( playerPath player.id )
        Nothing ->
          Cmd.none

home : Cmd Msg
home = newUrl "http://localhost:3000/"


playersDecoder : Decode.Decoder ( List Player )
playersDecoder = Decode.list playerDecoder

playerDecoder : Decode.Decoder Player
playerDecoder =
      decode Player
  |>  required "id" Decode.string
  |>  required "name" Decode.string
  |>  required "level" Decode.int
  |>  required "equip" Decode.string


onLinkClick : msg -> Attribute msg
onLinkClick message =
  let options = {
          stopPropagation = False
      ,   preventDefault = True
      }
  in onWithOptions "click" options
      ( Decode.succeed message )


savePlayersUrl : String
savePlayersUrl =
    "http://localhost:4000/players"

--savePlayerUrl : PlayerId -> String
playerUrl : PlayerId -> String
playerUrl playerId =
    "http://localhost:4000/players/" ++ playerId


-- // Player
savePlayerRequest : Method -> Player -> Http.Request Player
savePlayerRequest method player =
  let ( methodStr, decoder, urlId ) = case method of
        Patch-> ( "PATCH", playerDecoder, player.id )
        Post -> ( "POST", playerDecoder, "" )
        Delete -> ( "DELETE", Decode.succeed player, player.id )
  in Http.request {
        body = player
          |>  playerEncoder
          |>  Http.jsonBody
    ,   expect = Http.expectJson decoder
    ,   headers = [ ]
--  ,   method = "PATCH"
    ,   method = methodStr
    ,   timeout = Nothing
    ,   url = playerUrl urlId
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
      , ( "name", Encode.string player.name )
      , ( "level", Encode.int player.level )
      , ( "equip", Encode.string player.equip )
      ]
  in Encode.object attributes



---- // List Player
----savePlayersCmd : List Player -> Cmd Msg
----savePlayersCmd players = players
----  |>  savePlayersRequest
----  |>  Http.send Msgs.OnPlayersSave
--savePlayersCmd : Model -> Cmd Msg
--savePlayersCmd model = model
--  |>  savePlayersRequest
--  |>  Http.send Msgs.OnPlayersSave
--
--savePlayersRequest : Model -> Http.Request ( List Player )
----savePlayersRequest : List Player -> Http.Request Player
--savePlayersRequest model =
--    Http.request {
--    --  body = players
--        body = testPlayers
--          |>  playersEncoder
--          |>  Http.jsonBody
--    ,   expect = Http.expectJson playersDecoder
----  ,   expect = Http.expectJson playerDecoder
--    ,   headers = [ ]
--    ,   method = "PATCH"
----  ,   method = "POST"
----  ,   method = "PUT"
--    ,   timeout = Nothing
--    ,   url = savePlayersUrl
--    ,   withCredentials = False
--    }
--
--playersEncoder : List Player -> Encode.Value
--playersEncoder players =
----    playerEncoder testPlayer
--      List.map playerEncoder players
--  |>  Encode.list
--
--testPlayers : List Player
--testPlayers = [
--    testPlayer
--  , testPlayer
--  , testPlayer
--  ]
--
--testPlayer : Player
--testPlayer = {
--        id = "7"
--    ,   name = "test"
--    ,   level = 1
--    }


