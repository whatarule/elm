
module Players.List exposing (..)

import Html exposing (..)
import Html.Attributes exposing ( class, style, href )
import Html.Events exposing ( onClick )
import Msgs exposing ( Msg (..) )
import Models exposing ( Model, Player, Method(..) )
import RemoteData exposing ( WebData )
import Routing exposing ( playerPath, playersPath )
import Commands exposing (..)
import String
import Result
import Players.Edit exposing
  ( Equip, listEquip
  , colourValidation )

-- view : List Player -> Html Msg
-- view players = div [ ] [ nav, list players ]
--view : WebData ( List Player ) -> Html Msg
view : Model -> Html Msg
view model =
  div [ ] [
      nav
  --, maybeList response
    , maybeList model.players
  --, saveBtn model
    , errValidation model
    ]

nav : Html Msg
nav =
  div [ class "clearfix mb2 white bg-black" ] [
      div [ class "left p2" ] [ text "Players" ]
    ]

errValidation : Model -> Html Msg
errValidation model =
  let color = colourValidation model
  in div [ class "m3" ] [
      div [ class "col col-5", style [ ( "color", color ) ] ]
          [ text model.err ]
  ]

list : List Player -> Html Msg
list players =
--in
    div [ class "p2" ] [
      table [ ] [
        thead [ ] [
          th [ ] [ text "Id" ]
        , th [ ] [ text "Name" ]
        , th [ ] [ text "Level" ]
        , th [ ] [ text "Equipment" ]
        , th [ ] [ text "Bonus" ]
        , th [ ] [ text "Strength" ]
        , th [ ] [ text "Actions" ]
        ]
  --  , tbody [ ] ( List.map playerRow players )
      , tbody [ ] ( List.append
          ( List.map ( playerRow players ) players )
          [ ( playerRowNew players ) ]
        )
      ]
    ]

maybeList : WebData ( List Player ) -> Html Msg
maybeList response = case response of
    RemoteData.NotAsked ->
        text ""
    RemoteData.Loading ->
        text "Loading..."
    RemoteData.Success players ->
        list players
    RemoteData.Failure error ->
        text ( toString error )

playerRow : List Player -> Player -> Html Msg
playerRow players player =
  let bonus = equipBonus player
      strength = player.level + bonus
  in tr [ ] [
        td [ ] [ text ( player.id ) ]
    ,   td [ ] [ text player.name ]
    ,   td [ ] [ text ( toString player.level ) ]
    ,   td [ ] [ text player.equip ]
    ,   td [ ] [ text ( toString bonus )]
    ,   td [ ] [ text ( toString strength )]
    ,   td [ ] [ editBtn player ]
    ,   td [ ] [ deleteBtn player ]
    ]

equipBonus : Player -> Int
equipBonus player =
  let pick equip =
        player.equip == equip.name
      maybeEquip =
            List.filter pick listEquip
        |>  List.head
  in case maybeEquip of
      Just equip -> equip.bonus
      Nothing -> 0

playerRowNew : List Player -> Html Msg
playerRowNew players = tr [ ] [
        td [ ] [ ]
    ,   td [ ] [ ]
    ,   td [ ] [ ]
    ,   td [ ] [ ]
    ,   td [ ] [ ]
    ,   td [ ] [ ]
    ,   td [ ] [ addBtn players ]
    ,   td [ ] [ ]
    ]

-- editBtn : Player -> Html Msg
-- editBtn player =
--     let path = playerPath player.id
--     in a [ class "btn regular", href path, onLinkClick ( ChangeLocation path ) ] [
--             i [ class "fa fa-pencil mr1" ] [ ]
--         ,   text "Edit"
--         ]

editBtn : Player -> Html Msg
editBtn player =
    let path = playerPath player.id
    in a [ class "btn regular", href path
         , onLinkClick ( ChangeLocation path )
         ] [
          i [ class "fa fa-pencil mr1" ] [ ]
      ,   text "Edit"
      ]

addBtn : List Player -> Html Msg
addBtn players =
  let msg = AddPlayer players ( newPlayer players )
  in a [ class "btn regular"
       , onClick msg
       ] [
        i [ class "fa fa-pencil mr1" ] [ ]
      , text "Add"
      ]

newPlayer : List Player -> Player
newPlayer players = {
      id = newId players
  ,   name = ""
  ,   level = 1
  ,   equip = ""
  }

newId : List Player -> String
newId players = players
  |>  lastId
  |>  String.toInt
  |>  Result.withDefault 1
  |>  (+) 1
  |>  toString

lastId : List Player -> String
lastId players =
    let lastPlayer = players
      |>  List.reverse
      |>  List.head
    in case lastPlayer of
        Just player -> player.id
        Nothing -> "1"

deleteBtn : Player -> Html Msg
deleteBtn deletedPlayer =
    let msg = DeletePlayer deletedPlayer
    in a [ class "btn regular", onClick msg ] [
          text "Delete"
      ]

--saveBtn : Model -> Html Msg
--saveBtn model =
--  div [ class "clearfix mb2 black bg-white p1" ] [
--    a [ class "btn regular"
--      , href playersPath
--      , onLinkClick ( SavePlayers model )
--      ] [
--      --i [ class "fa fa-chevron-left mr1" ] [ ]
--        i [ class "fa fa-chevron-right mr1" ] [ ]
--      , text "Save"
--      ]
--    ]


