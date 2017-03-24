
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)

main : Program Never Model Msg
main = program {
        init = init
    ,   view = view
    ,   update = update
    ,   subscriptions = subscriptions
    }

type alias Model = {
        fontsize : FontSize
    ,
    }




