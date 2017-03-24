
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing ( onClick )
import Random

main : Program Never Model Msg
main = program {
        init = init
    ,   view = view
    ,   update = update
    ,   subscriptions = subscriptions
    }

type alias Model = {
        dieFace : DieFace
    ,   dieFaces : DieFaces
    }

type alias DieFace = Int
type alias DieFaces = {
        first : DieFace
    ,   second : DieFace
    }

view : Model -> Html Msg
view model =
    div [] [
            h1 [] [ text ( toString model.dieFace ) ]
        ,   img [ alt ( toString model.dieFaces.first ) ] []
        ,   img [ alt ( toString model.dieFaces.second ) ] []
        ,   br [] []
        ,   button [ onClick Roll ] [ text "Roll" ]
        ]


type Msg =
        Roll
    |   NewFace DieFace
    |   NewFaceFirst DieFace
    |   NewFaceSecond DieFace

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    let dieFaces = model.dieFaces
    in case msg of
        Roll ->
        --  ( model, Random.generate NewFace ( Random.int 1 6 ) )
            ( model, randomFace NewFaceFirst )
        NewFace newFace ->
            ( { model | dieFace = newFace }, Cmd.none )
        NewFaceFirst newFace ->
            ( { model | dieFaces = { dieFaces | first = newFace } }, randomFace NewFaceSecond )
        NewFaceSecond newFace ->
            ( { model | dieFaces = { dieFaces | second = newFace } }, Cmd.none )

randomFace : ( DieFace -> Msg ) -> Cmd Msg
randomFace msg = Random.generate msg ( Random.int 1 6 )

init : ( Model, Cmd Msg )
init = ( Model 1 ( DieFaces 1 1 ), Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions model = Sub.none
