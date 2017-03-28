
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import List
import Markdown

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

init : ( Model, Cmd Msg )
init = ( Model Medium intro, Cmd.none )

intro : String
intro = """
# Anna Karenina
## Chapter 1
Happy families are all alike; every unhappy family is unhappy in its own way.
Everything was in confusion in the Oblonskys’ house. The wife had discovered
that the husband was carrying on an intrigue with a French girl, who had been
a governess in their family, and she had announced to her husband that she
could not go on living in the same house with him...
"""

type Msg = SwitchTo FontSize

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model = case msg of
    SwitchTo newFontSize ->
      ( { model | fontsize = newFontSize }, Cmd.none )

subscriptions : Model -> Sub Msg
subscriptions model = Sub.none


view : Model -> Html Msg
view model =
  div [] [
        viewPicker [
            ( "Small", SwitchTo Small )
        ,   ( "Medium", SwitchTo Medium )
        ,   ( "Large", SwitchTo Large )
        ]
    ,   Markdown.toHtml [ sizeToStyle model.fontsize ] model.content
    ]

viewPicker : List ( String, Msg ) -> Html Msg
viewPicker options =
  fieldset [] ( List.map viewRadio options )

viewRadio : ( String, Msg ) -> Html Msg
viewRadio ( value, msg ) =
  label [] [
        input [ type_ "radio", name "font-size", onClick msg ] []
    ,   text value
    ]

sizeToStyle : FontSize -> Attribute Msg
sizeToStyle fontsize =
    let size = case fontsize of
        Small -> "0.8rem"
        Medium -> "1.0rem"
        Large -> "1.2rem"
    in style [ ( "font-size", size ) ]



