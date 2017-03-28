
module Players.Edit exposing (..)

import Html exposing (..)
import Html.Attributes exposing ( .. )
import Html.Events exposing ( .. )
import Msgs exposing ( Msg (..) )
import Models exposing ( Model, Player )
import Routing exposing ( playersPath )
import Commands exposing (..)
import Guards exposing ( (|=), (=>) )


view : Model -> Player -> Html Msg
view model player =
  div [ ] [
        nav player
    ,   form player
    ,   errValidation model
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

form : Player -> Html Msg
form player =
  div [ class "m3" ] [
      h1 [ ] [ text player.name ]
    , formName player
    , formLevel player
    , formValidation player
    ]

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



