
module Main exposing (..)

import Html exposing ( Html, button, div, div, text, program )
import Html.Events exposing ( onClick )


-- // model

type alias Model = Bool

init : ( Model, Cmd Msg )
init = ( False, Cmd.none )


-- // messages

type Msg = Expand | Collapse


-- // view

view : Model -> Html Msg
view model = if model then
    div [ ] [
        button [ onClick Collapse ] [ text "collapse" ],
        text "widget"
    ] else
    div [ ] [
        button [ onClick Expand ] [ text "expand" ]
        ]

-- // update

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model = case msg of
    Expand -> ( True, Cmd.none )
    Collapse -> ( False, Cmd.none )


-- // subscriptions

subscriptions : Model -> Sub Msg
subscriptions model = Sub.none


-- // main

main = program {
        init = init,
        view = view,
        update = update,
        subscriptions = subscriptions
    }



