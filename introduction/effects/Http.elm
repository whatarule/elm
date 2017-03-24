
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Http
import Json.Decode as Decode

main : Program Never Model Msg
main = program {
        init = init
    ,   update = update
    ,   view = view
    ,   subscriptions = subscriptions
    }

type alias Model = {
        topic : String
    ,   gitUrl : String
    ,   message : String
    }

init : ( Model, Cmd Msg )
init = ( Model "cats" "waiting.gif" "", Cmd.none )


type Msg =
          MorePlease
      |   NewGif ( Result Http.Error String )
      |   Topic String

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model = case msg of
    MorePlease ->
        ( model, getRandomGif model.topic )
    NewGif ( Ok newUrl ) ->
        ( { model | gitUrl = newUrl }, Cmd.none )
    NewGif ( Err message ) ->
        ( { model | message = toString message }, Cmd.none )
    Topic topic ->
        ( { model | topic = topic }, Cmd.none )

getRandomGif : String -> Cmd Msg
getRandomGif topic =
    let url = "https://api.giphy.com/v1/gifs/random?api_key=dc6zaTOxFJmzC&tag=" ++ topic
        request = Http.get url decodeGifUrl
    in Http.send NewGif request

decodeGifUrl : Decode.Decoder String
decodeGifUrl = Decode.at [ "data", "image_url" ] Decode.string



view : Model -> Html Msg
view model = div [] [
        input [ type_ "text", placeholder "topic", onInput Topic ] [ ]
    ,   select [ placeholder "topic", onInput Topic ] [
                option [] [ text "cats" ]
            ,   option [] [ text "dogs" ]
            ,   option [] [ text "birds" ]
            ]
    ,   br [] []
    ,   button [ onClick MorePlease ] [ text "More please!" ]
    ,   br [] []
    ,   h2 [] [ text model.topic ]
    ,   img [ src model.gitUrl ] []
    ,   br [] []
    ,   div [ style [ ( "color", "red" ) ] ] [ text model.message ]
    ]

subscriptions : Model -> Sub Msg
subscriptions model = Sub.none
