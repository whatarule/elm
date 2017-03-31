
module Players.Edit exposing (..)

import Html exposing (..)
import Html.Attributes exposing ( .. )
import Html.Events exposing ( .. )
import Msgs exposing ( Msg (..) )
import Models exposing ( Model, Player, Method(..) )
import Routing exposing ( playersPath )
import Commands exposing (..)
import Guards exposing ( (|=), (=>) )


view : Model -> Player -> Html Msg
view model player =
  div [ ] [
      nav player
    , saveBtn player
    , form player
    , errValidation model
    ]

nav : Player -> Html Msg
nav player =
  div [ class "clearfix mb2 white bg-black p1" ] [
      listBtn
    ]

--err : Model -> Html Msg
--err model =
--    let newModel = modelValidation model
--        ( color, message ) =
--            ( newModel.validation.color, newModel.validation.message )
--    in div [ class "m3" ] [
--        div [ class "col col-5", style [ ( "color", "red" ) ] ] [ text model.err ]
--    ]

errValidation : Model -> Html Msg
errValidation model =
--let color =
--     = ( model.err == "Unchanged" ) => "gray"
--    |= ( model.err == "Changed Successfully" ) => "green"
--    |= "red"
  let color = colourValidation model
  in div [ class "clearfix m3" ] [
      div [ class "col col-5"
          , style [ ( "color", color ) ]
        ] [ text model.err ]
  ]

colourValidation : Model -> String
colourValidation model =
  case model.err of
    "Unchanged" ->
        "grey"
    "Saved" ->
        "green"
    _ ->
        "red"

form : Player -> Html Msg
form player =
  div [ class "m3" ] [
      h1 [ ] [ text player.name ]
    , formName player
    , formLevel player
    , formEquip player
    , formValidation player
    ]


--formString : String -> String -> Msg -> Html Msg
--formString fieldName fieldValue msg =
--  div [ class "clearfix py1" ] [
--    div [ class "col col-5" ]
--        [ text fieldName ]
--  , div [ class "col col-7" ] [
--      span [ class "h2 bold" ]
--           [ text fieldValue ]
--    , input [
--        class "ml1 h1"
--      , placeholder fieldValue
--      , onInput msg
--      ] []
--    ]
--  ]

formName : Player -> Html Msg
formName player =
  div [ class "clearfix py1" ] [
    div [ class "col col-5" ]
        [ text "Name" ]
  , div [ class "col col-7" ] [
      span [ class "h2 bold" ]
           [ text player.name ]
    , input [
        class "ml1 h1"
      , placeholder player.name
      , onInput ( Msgs.ChangeName player )
      ] []
    ]
  ]

formEquip : Player -> Html Msg
formEquip player =
  div [ class "clearfix py1" ] [
    div [ class "col col-5" ]
        [ text "Equipment" ]
  , div [ class "col col-7" ] [
      span [ class "h2 bold" ]
           [ text player.equip ]
  --, input [
  --    class "ml1 h1"
  --  , placeholder player.equip
  --  , onInput ( Msgs.ChangeEquip player )
  --  ] []
    , select [
        class "ml1 h2"
      , onInput ( Msgs.ChangeEquip player ) ]
      --  option [ value "" ] [ text "" ]
      --, option [ value "Steel sword" ] [ text "Steel sword" ]
      --  viewOption player ""
      --, viewOption player "Steel sword"
          ( List.map ( optionEquip player ) listEquip )
    ]
  ]

type alias Equip = {
    name : String
  , bonus : Int
  }

listEquip : List Equip
listEquip = [
    Equip "" 0
  , Equip "Steel sword" 3
  , Equip "Silver sword" 7
  ]

optionEquip : Player -> Equip -> Html Msg
optionEquip player equip =
  let bool = player.equip == equip.name
  in option [ value equip.name, selected bool ] [ text equip.name ]

formValidation : Player -> Html Msg
formValidation player =
  let ( message, color )
     = ( player.name == "" ) =>
        ( "Name is empty", "red" )
    |=  ( "", "" )
  in div [ class "clearfix py1" ] [
      div [ class "col col-5"
          , style [ ( "color", color ) ]
          ] [ text message ]
    ]

formLevel : Player -> Html Msg
formLevel player =
  div [ class "clearfix py1" ] [
      div [ class "col col-5" ]
        [ text "Level" ]
    , div [ class "col col-7" ] [
        span [ class "h2 bold" ]
          [ text ( toString player.level ) ]
      , btnLevelDecrease player
      , btnLevelIncrease player
      ]
  ]

btnLevelDecrease : Player -> Html Msg
btnLevelDecrease player =
  let message = Msgs.ChangeLevel player -1
  in a [ class "btn ml1 h1"
       , onClick message
       ] [ i [ class "fa fa-minus-circle" ] [ ]
      ]

btnLevelIncrease : Player -> Html Msg
btnLevelIncrease player =
  let message = Msgs.ChangeLevel player 1
  in a [ class "btn ml1 h1"
       , onClick message
       ] [ i [ class "fa fa-plus-circle" ] [ ]
      ]

listBtn : Html Msg
listBtn =
  a [ class "btn regular"
    , href playersPath
    , onLinkClick ( ChangeLocation playersPath )
    ] [
      i [ class "fa fa-chevron-left mr1" ] [ ]
    , text "List"
    ]

saveBtn : Player -> Html Msg
saveBtn player =
  div [ class "clearfix mb2 black bg-white p1" ] [
    a [ class "btn regular"
      , href playersPath
      , onLinkClick ( SavePlayer Patch player )
      ] [
      --i [ class "fa fa-chevron-left mr1" ] [ ]
        i [ class "fa fa-chevron-right mr1" ] [ ]
      , text "Save"
      ]
    ]


