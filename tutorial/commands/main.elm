
module Main exposing (..)

import Html exposing ( Html, div, button, text, program )
import Html.Events exposing ( onClick )
import Random


-- // model
type alias Model = Int

init : ( Model, Cmd Msg )
init = ( 1, Cmd.none )


-- // messages
type Msg = Roll | OnResult Int


-- // view
view : Model -> Html Msg
view model = div [ ] [
        button [ onClick Roll ] [ text "roll" ],
        text ( toString model )
    ]


-- // update
update : Msg -> Model -> ( Model, Cmd Msg )
update msg model = case msg of
    Roll -> ( model, Random.generate OnResult ( Random.int 1 6 ) )
    OnResult res -> ( res, Cmd.none )


-- // main
main : Program Never Model Msg
main = program {
        init = init,
        view = view,
        update = update,
        subscriptions = ( always Sub.none )
    }


