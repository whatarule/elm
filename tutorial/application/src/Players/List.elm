
module Players.List exposing (..)

import Html exposing (..)
import Html.Attributes exposing ( class, style, href )
import Html.Events exposing ( onClick )
import Msgs exposing ( Msg (..) )
import Models exposing ( Model, Player )
import RemoteData exposing ( WebData )
import Routing exposing ( playerPath )
import Commands exposing (..)
import String
import Result

-- view : List Player -> Html Msg
-- view players = div [ ] [ nav, list players ]
--view : WebData ( List Player ) -> Html Msg
view : Model -> Html Msg
view model =
  div [ ] [
      nav
  --, maybeList response
    , maybeList model.players
    , errValidation model
    ]

nav : Html Msg
nav = div [ class "clearfix mb2 white bg-black" ] [
        div [ class "left p2" ] [ text "Players" ]
    ]

errValidation : Model -> Html Msg
errValidation model =
  let color = case model.err of
      "Unchanged" ->
          "grey"
      "Changed successfully" ->
          "green"
      _ ->
          "red"
  in div [ class "m3" ] [
      div [ class "col col-5", style [ ( "color", color ) ] ]
          [ text model.err ]
  ]

list : List Player -> Html Msg
list players =
--let newPlayer = {
--        id = ( lastId players ) + 1
--            |> toString
--    ,   name = ""
--    ,   level = 1
--    }
--in
    div [ class "p2" ] [
      table [ ] [
        thead [ ] [
          th [ ] [ text "Id" ]
        , th [ ] [ text "Name" ]
        , th [ ] [ text "Level" ]
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
playerRow players player = tr [ ] [
        td [ ] [ text ( player.id ) ]
    ,   td [ ] [ text player.name ]
    ,   td [ ] [ text ( toString player.level ) ]
    ,   td [ ] [ editBtn player ]
    ,   td [ ] [ deleteBtn players player ]
    ]

playerRowNew : List Player -> Html Msg
playerRowNew players = tr [ ] [
        td [ ] [ ]
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
    in a [ class "btn regular", href path, onLinkClick ( ChangeLocation path ) ] [
          i [ class "fa fa-pencil mr1" ] [ ]
      ,   text "Edit"
      ]

addBtn : List Player -> Html Msg
addBtn players =
    let msg = AddPlayer players newPlayer
        newPlayer = {
            id = newId players
        ,   name = ""
        ,   level = 1
        }
    in a [ class "btn regular", onClick msg ] [
          i [ class "fa fa-pencil mr1" ] [ ]
        , text "Add"
        ]

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

deleteBtn : List Player -> Player -> Html Msg
deleteBtn players deletedPlayer =
    let msg = DeletePlayer players deletedPlayer
    in a [ class "btn regular", onClick msg ] [
          text "Delete"
      ]


