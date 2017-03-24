
module Main exposing (..)

import Msgs exposing ( Msg )
import Models exposing ( Model, initialModel )
import Update exposing ( update )
import View exposing ( view )
import Commands exposing ( fetchPlayers )
import Navigation exposing ( Location )
import Routing

init : Location -> ( Model, Cmd Msg )
init location =
    let currnetRoute = Routing.parseLocation location
    in ( initialModel currnetRoute, fetchPlayers )

subscriptions : Model -> Sub Msg
subscriptions model = Sub.none

main : Program Never Model Msg
main = Navigation.program Msgs.OnLocationChange {
        init = init
    ,   view = view
    ,   update = update
    ,   subscriptions = subscriptions
    }