
import Time exposing ( Time, second )
import Html exposing (..)
import Html.Events exposing (..)
import Svg exposing (..)
import Svg.Attributes exposing (..)
import Guards exposing (..)

main : Program Never Model Msg
main = program {
        init = init
    ,   view = view
    ,   update = update
    ,   subscriptions = subscriptions
    }


type alias Model = {
        time : Time
    ,   update : Bool
    }

init : ( Model, Cmd Msg )
init = ( Model 0 True, Cmd.none )


type Msg = Tick Time | Pause

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model = case msg of
    Tick newTime ->
        ( { model | time = newTime }, Cmd.none )
    Pause ->
        ( { model | update = not model.update }, Cmd.none )

subscriptions : Model -> Sub Msg
subscriptions model
     =  model.update => Time.every second Tick
    |=  Sub.none

type alias Hand = {
        x : String
    ,   y : String
    }

hand : Float -> Float -> Hand
hand length angle = {
        x = toString ( 50 + length * cos angle )
    ,   y = toString ( 50 + length * sin angle )
    }

view : Model -> Html Msg
view model =
    let angle = {
                hour = turns ( Time.inHours model.time )
            ,   minute = turns ( Time.inSeconds model.time )
            ,   second = turns ( Time.inMinutes model.time )
            }
    --  handX = toString ( 50 + 40 * cos angle.second )
    --  handY = toString ( 50 + 40 * sin angle.second )
        handHour = hand 30 angle.hour
        handMinute = hand 35 angle.minute
        handSecond = hand 40 angle.second
    in div [] [
            svg [ viewBox "0 0 100 100", width "300px" ] [
                    circle [ cx "50", cy "50", r "45", fill "#0B79CE" ] []
                ,   viewLine handHour
                ,   viewLine handMinute
                ,   viewLine handSecond
                ]
        ,   br [] []
        ,   button [ onClick Pause ] [ Html.text "pause" ]
        ]

viewLine : Hand -> Html Msg
viewLine hand =
    line [ x1 "50", y1 "50", x2 hand.x, y2 hand.y, stroke "#023963" ] []
