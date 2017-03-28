
module Update exposing (..)

import Msgs exposing ( Msg )
import Models exposing ( Model, Player )
import Routing exposing ( parseLocation )
import Navigation exposing ( newUrl )
import Commands exposing ( Method(..), savePlayerCmd, savePlayersCmd, fetchPlayers )
import RemoteData
import List

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model = case msg of

  Msgs.ChangeLocation path ->
    ( model, newUrl path )
  Msgs.OnFetchPlayers response ->
    ( { model | players = response }, Cmd.none )
  Msgs.OnLocationChange location ->
    let newRoute = parseLocation location
    in ( { model | route = newRoute }, Cmd.none )

  Msgs.ChangeLevel player howMuch ->
    let updatedPlayer = { player | level = player.level + howMuch }
    in ( model, savePlayerCmd Patch updatedPlayer )
  Msgs.ChangeName player newName ->
    let updatedPlayer = { player | name = newName }
    in ( model, savePlayerCmd Patch updatedPlayer )

  Msgs.AddPlayer players newPlayer ->
  --let newPlayers = addPlayer players newPlayer
  --in
    ( model, savePlayerCmd Post newPlayer )
  Msgs.DeletePlayer players deletedPlayer ->
  --let newPlayers = deletePlayer players deletedPlayer
  --in
    ( model, savePlayerCmd Delete deletedPlayer )
--  Msgs.ChangePlayers model newPlayers ->
--      let updatedPlayers = { model | players = newPlayers }
--      in ( model, savePlayersCmd updatedPlayers )

  Msgs.OnPlayerSave ( Ok player ) ->
  --( updatePlayer model player , Cmd.none )
    ( updatePlayer model player , fetchPlayers )
  Msgs.OnPlayerSave ( Err error ) ->
    ( { model | err = toString error }, Cmd.none )
  Msgs.OnPlayersSave ( Ok players ) ->
    ( updatePlayers model players , Cmd.none )
  Msgs.OnPlayersSave ( Err error ) ->
    ( { model | err = toString error }, Cmd.none )


updatePlayer : Model -> Player -> Model
updatePlayer model updatedPlayer =
    let pick currentPlayer =
        if updatedPlayer.id == currentPlayer.id
            then updatedPlayer
            else currentPlayer
        updatePlayerList players = List.map pick players
        updatedPlayers = RemoteData.map updatePlayerList model.players
    in { model | players = updatedPlayers, err = "Changed successfully" }

updatePlayers : Model -> List Player -> Model
updatePlayers model players =
    let updatedPlayers = RemoteData.succeed players
    in { model | players = updatedPlayers, err = "Changed successfully" }

addPlayer : List Player -> Player -> List Player
addPlayer players newPlayer =
    List.append players [ newPlayer ]

deletePlayer : List Player -> Player -> List Player
deletePlayer players deletedPlayer =
    let pick currentPlayer =
          not ( deletedPlayer.id == currentPlayer.id )
    in List.filter pick players



