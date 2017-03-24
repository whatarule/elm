
module App exposing (..)

import Html exposing ( Html, div, text, program )


-- // model

type alias Model = String

init : ( Model, Cmd Msg )
init = ( "hello", Cmd.none )


-- // messages

type Msg = NoOp


-- // view

view : Model -> Html Msg
view model = div [ ] [ text model ]


-- // update

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model = case msg of
    NoOp -> ( model, Cmd.none )


-- // subscriptions

subscriptions : Model -> Sub Msg
subscriptions model = Sub.none


-- // main

main = program {
        init = init
    ,   view = view
    ,   update = update
    ,   subscriptions = subscriptions
    }



