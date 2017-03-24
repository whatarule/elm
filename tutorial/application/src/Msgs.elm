
module Msgs exposing (..)

import Models exposing ( Player )
import RemoteData exposing ( WebData )
import Navigation exposing ( Location )
import Http

type Msg =
        ChangeLocation String
    |   OnFetchPlayers ( WebData ( List Player ) )
    |   OnLocationChange Location
    |   ChangeLevel Player Int
    |   ChangeName Player String
    |   OnPlayerSave ( Result Http.Error Player )
