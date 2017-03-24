
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing ( onInput, onClick )
import Guards exposing ( (|=), (=>) )
import Char

main : Program Never Model Msg
main = Html.beginnerProgram {
        model = model
    ,   view = view
    ,   update = update
    }


type alias Model = {
        name : String
    ,   password : String
    ,   passwordAgain : String
    ,   age : String
    ,   validation : {
            color : String
        ,   message : String
        }
    }

model : Model
model = Model "" "" "" "" { color = "", message = "" }


type Msg =
        Name String
    |   Password String
    |   PasswordAgain String
    |   Age String
    |   Submit

update : Msg -> Model -> Model
update msg model = case msg of
      Name name ->
          { model | name = name }
      Password password ->
          { model | password = password }
      PasswordAgain passwordAgain ->
          { model | passwordAgain = passwordAgain }
      Age age ->
          { model | age = age }
      Submit ->
          let newModel = modelValidation model
          in { model | validation = newModel.validation }

view : Model -> Html Msg
view model = div [ ] [
--      input [ type_ "text", placeholder "Name", onInput Name ] [ ]
--  ,   input [ type_ "password", placeholder "Password", onInput Password ] [ ]
--  ,   input [ type_ "password", placeholder "Re-enter Password", onInput PasswordAgain ] [ ]
        viewInput model "text" "Name" Name
    ,   viewInput model "password" "Password" Password
    ,   viewInput model "password" "Re-enter Password" PasswordAgain
    ,   viewInput model "int" "Age" Age
    ,   button [ onClick Submit ] [ text "Submit" ]
    ,   div [ style [ ( "color", model.validation.color ) ] ] [ text model.validation.message ]
    ]

viewInput : Model -> String -> String -> ( String -> Msg ) -> Html Msg
viewInput model strType strPlaceholder typeMsg =
    input [ type_ strType, placeholder strPlaceholder, onInput typeMsg ] [ ]

viewValidation : Model -> Html Msg
viewValidation model =
    --  if model.password == model.passwordAgain
    --  then ( "green", "OK" )
    --  else ( "red", "Passwords do not match!" )
    let newModel = modelValidation model
        ( color, message ) =
            ( newModel.validation.color, newModel.validation.message )
    in div [ style [ ( "color", color ) ] ] [ text message ]

modelValidation : Model -> Model
modelValidation model =
{-
    let ( color, message ) =
        if not ( model.password == model.passwordAgain )
            then ( "red", "Passwords do not match!" )
        else if not ( String.length model.password > 8 )
            then ( "red", "Your password is too short!" )
        else if not ( String.any Char.isUpper model.password )
            then ( "red", "Your password do not contain uppercase!" )
        else if not ( String.any Char.isLower model.password )
            then ( "red", "Your password do not contain lowercase!" )
        else if not ( String.any Char.isDigit model.password )
            then ( "red", "Your password do not contain any numeric character!" )
        else if not ( String.all Char.isDigit model.age )
            then ( "red", "Age is not a number!" )
        else ( "green", "OK" )
-}
    let ( color, message )
           = not ( model.password == model.passwordAgain ) =>
              ( "red", "Passwords do not match!" )
          |= not ( String.length model.password > 8 ) =>
              ( "red", "Your password is too short!" )
          |= not ( String.any Char.isUpper model.password ) =>
              ( "red", "Your password do not contain uppercase!" )
          |= not ( String.any Char.isLower model.password ) =>
             ( "red", "Your password do not contain lowercase!" )
          |= not ( String.any Char.isDigit model.password ) =>
             ( "red", "Your password do not contain any numeric character!" )
          |= not ( String.all Char.isDigit model.age ) =>
             ( "red", "Age is not a number!" )
          |= ( "green", "OK" )
    in { model | validation = { color = color, message = message } }
