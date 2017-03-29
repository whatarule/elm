
module Msgs exposing (..)

import Models exposing ( Model, Player )
import RemoteData exposing ( WebData )
import Navigation exposing ( Location )
import Http

type Msg =
        ChangeLocation String
    |   OnFetchPlayers ( WebData ( List Player ) )
    |   OnLocationChange Location
    |   ChangeLevel Player Int
    |   ChangeName Player String
    |   AddPlayer ( List Player ) Player
    |   DeletePlayer ( List Player ) Player
--  |   ChangePlayers Model ( List Player )
    |   OnPlayerSave ( Result Http.Error Player )
--  |   OnPlayersSave ( Result Http.Error ( List Player ) )


