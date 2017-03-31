
module Msgs exposing (..)

import Models exposing ( Model, Player, Method )
import RemoteData exposing ( WebData )
import Navigation exposing ( Location )
import Http

type Msg =
    OnFetchPlayers ( WebData ( List Player ) )
  | ChangeLocation String
  | OnLocationChange Location
  | ChangeLevel Player Int
  | ChangeName Player String
  | ChangeEquip Player String
  | AddPlayer ( List Player ) Player
  | DeletePlayer Player
--| ChangePlayers Model Player
  | SavePlayer Method Player
--| SavePlayers Model
  | OnPlayerSave ( Result Http.Error Player )
--| OnPlayersSave ( Result Http.Error ( List Player ) )


