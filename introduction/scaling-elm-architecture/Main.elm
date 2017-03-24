
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
    ,   content : String
    }

type FontSize = Small | Medium | Large

type Msg = SwitchTo FontSize
