
module Update exposing (..)

import Msgs exposing ( Msg )
import Models exposing ( Model, Player, Method(..), Route(..) )
import Routing exposing ( parseLocation, playerPath )
import Navigation exposing ( newUrl )
import Commands exposing
  ( savePlayerCmd, fetchPlayers
--, savePlayersCmd
  , checkNewPlayer, home )
import RemoteData

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model = case msg of

  Msgs.OnFetchPlayers response ->
  --( { model | players = response }, Cmd.none )
    ( { model | players = response }
    , checkNewPlayer response )
  --( { model | players = response
  --          , err = "" }
  --, checkNewPlayer response )
  Msgs.ChangeLocation path ->
    ( model, newUrl path )
  --( { model | err = "" }, newUrl path )
  Msgs.OnLocationChange location ->
    let newRoute = parseLocation location
  --in ( { model | route = newRoute }, Cmd.none )
    in ( { model | route = newRoute
              -- , err = "Unchanged"
         }, Cmd.none )

  Msgs.ChangeLevel player howMuch ->
    let updatedPlayer = { player | level = player.level + howMuch }
  --in ( model, savePlayerCmd Patch updatedPlayer )
    in ( updatePlayer model updatedPlayer, Cmd.none )
  Msgs.ChangeName player newName ->
    let updatedPlayer = { player | name = newName }
  --in ( model, savePlayerCmd Patch updatedPlayer )
    in ( updatePlayer model updatedPlayer, Cmd.none )
  Msgs.ChangeEquip player newEquip ->
    let updatedPlayer = { player | equip = newEquip }
    in ( updatePlayer model updatedPlayer, Cmd.none )

  Msgs.AddPlayer players newPlayer ->
  --let newPlayers = addPlayer players newPlayer
  --let path = playerPath newPlayer.id
  --in ( model, newUrl path )
    ( { model | err = "Unsaved" }
    , savePlayerCmd Post newPlayer )
  Msgs.DeletePlayer deletedPlayer ->
  --let newPlayers = deletePlayer players deletedPlayer
  --in
    ( { model | err = "Unsaved" }
    , savePlayerCmd Delete deletedPlayer )
--Msgs.ChangePlayers model newPlayers ->
--    let updatedPlayers = { model | players = newPlayers }
--    in ( model, savePlayersCmd updatedPlayers )

  Msgs.SavePlayer method player ->
    ( model, savePlayerCmd method player )
--Msgs.SavePlayers model ->
--  ( model, savePlayersCmd model )
  Msgs.OnPlayerSave ( Ok player ) ->
  --( updatePlayer model player , Cmd.none )
    ( { model | err = "Saved" }, fetchPlayers )
  --( updatePlayer model player , checkNewPlayer player )
  Msgs.OnPlayerSave ( Err error ) ->
    ( { model | err = toString error }, Cmd.none )
--Msgs.OnPlayersSave ( Ok players ) ->
--  ( updatePlayers model players , Cmd.none )
--Msgs.OnPlayersSave ( Err error ) ->
--  ( { model | err = toString error }, Cmd.none )

--Msgs.EditNewPlayer player ->
--  ( model, editNewPlayer player )


updatePlayer : Model -> Player -> Model
updatePlayer model updatedPlayer =
  let pick currentPlayer =
      if updatedPlayer.id == currentPlayer.id
          then updatedPlayer
          else currentPlayer
      updatePlayerList players = List.map pick players
      updatedPlayers = RemoteData.map updatePlayerList model.players
  in { model |
         players = updatedPlayers
       , err = "Unsaved"
       }

--updatePlayers : Model -> List Player -> Model
--updatePlayers model players =
--    let updatedPlayers = RemoteData.succeed players
--    in { model |
--          players = updatedPlayers
--        , err = "Unsaved"
--        }

--addPlayer : List Player -> Player -> List Player
--addPlayer players newPlayer =
--    List.append players [ newPlayer ]
--
--deletePlayer : List Player -> Player -> List Player
--deletePlayer players deletedPlayer =
--    let pick currentPlayer =
--          not ( deletedPlayer.id == currentPlayer.id )
--    in List.filter pick players



