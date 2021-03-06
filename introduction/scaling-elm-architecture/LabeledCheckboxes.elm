
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
        notifications : Bool
    ,   autoplay : Bool
    ,   location : Bool
    }

init : ( Model, Cmd Msg )
init = ( Model False False False, Cmd.none )

type Msg =
        ToggleNotifications
    |   ToggleAutoplay
    |   ToggleLocation

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model = case msg of
    ToggleNotifications ->
        ( { model | notifications = not model.notifications }, Cmd.none )
    ToggleAutoplay ->
        ( { model | autoplay = not model.autoplay }, Cmd.none )
    ToggleLocation ->
        ( { model | location = not model.location }, Cmd.none )

subscriptions : Model -> Sub Msg
subscriptions model = Sub.none

view : Model -> Html Msg
view model =
    fieldset [] [
        checkbox ToggleNotifications "Email Notifications"
    ,   checkbox ToggleAutoplay "Video Autoplay"
    ,   checkbox ToggleLocation "Use Location"
    ]

checkbox : Msg -> String -> Html Msg
checkbox msg name =
    label [] [
        input [ type_ "checkbox", onClick msg ] []
    ,   text name
    ]
