
module Main exposing (..)

import Html exposing ( Html, div, text, program )
import Mouse
import Keyboard


-- // model
type alias Model = Int

init : ( Model, Cmd Msg )
init = ( 0, Cmd.none )

-- // messages
type Msg = MouseMsg Mouse.Position | KeyMsg Keyboard.KeyCode


-- // view
view : Model -> Html Msg
view model = div [ ] [
        text ( toString model )
    ]


-- // update
update : Msg -> Model -> ( Model, Cmd Msg )
update msg model = case msg of
      MouseMsg position -> ( model + 1, Cmd.none )
      KeyMsg code -> ( model + 2, Cmd.none )


-- // subscriptions
subscriptions : Model -> Sub Msg
subscriptions model = Sub.batch [
        Mouse.clicks MouseMsg,
        Keyboard.downs KeyMsg
    ]


-- // main
main : Program Never Model Msg
main = program {
        init = init,
        view = view,
        update = update,
        subscriptions = subscriptions
    }



