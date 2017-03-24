
module Main exposing (..)

import Html exposing ( Html, button, div, text, program )
import Html.Events exposing ( onClick )


-- // model
type alias Model = Int

init : ( Model, Cmd Msg )
init = ( 0, Cmd.none )


-- // messages
type Msg = Increment Int


-- // view
view : Model -> Html Msg
view model = div [ ] [
       button [ onClick ( Increment 2 ) ] [ text "+" ],
       text ( toString model )
    ]


-- // update
update : Msg -> Model -> ( Model, Cmd Msg )
update msg model = case msg of
      Increment howMuch -> ( model + howMuch, Cmd.none )


-- // subscriptions
subscriptions : Model -> Sub Msg
subscriptions mode = Sub.none


-- // main
main : Program Never Model Msg
main = program {
        init = init,
        view = view,
        update = update,
        subscriptions = subscriptions
    }



