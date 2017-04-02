Sample Elm application wirh "Improvements"
=
- [from Elm Tutorial][tutorial]

[tutorial]: https://www.elm-tutorial.org/en/

### [List of "Improvements"][improvements] ###
- Create and delete players
- Change the name of a player
- Show an error message when an Http request fails
- Optimistic updates
- Validations
- Add perks and bonuses

[improvements]: https://www.elm-tutorial.org/en/09-conclusion/01-improvements.html

# Overview
- Picking up main additional codes for each feature.
- Entire structure was adjusted for additions with extra codes.

[edit]: https://github.com/whatarule/elm/tree/master/tutorial/application/src/Players/Edit.elm
[list]: https://github.com/whatarule/elm/tree/master/tutorial/application/src/Players/List.elm
[model]: https://github.com/whatarule/elm/tree/master/tutorial/application/src/Model.elm
[update]: https://github.com/whatarule/elm/tree/master/tutorial/application/src/Update.elm
[commands]: https://github.com/whatarule/elm/tree/master/tutorial/application/src/Commands.elm

### Create and delete players
- Change save Cmd to be able to use other HTTP methods
```elm
savePlayerRequest : Method -> Player -> Http.Request Player
savePlayerRequest method player =
  let ( methodStr, decoder, urlId ) = case method of
        Patch-> ( "PATCH", playerDecoder, player.id )
        Post -> ( "POST", playerDecoder, "" )
        Delete -> ( "DELETE", Decode.succeed player, player.id )
  in Http.request {
        body = player
          |>  playerEncoder
          |>  Http.jsonBody
    ,   expect = Http.expectJson decoder
    ,   headers = [ ]
--  ,   method = "PATCH"
    ,   method = methodStr
    ,   timeout = Nothing
    ,   url = playerUrl urlId
    ,   withCredentials = False
    }

```
[on "src/Commands.elm"][commands]

### Change the name of a player
- Add "formName", based on "formLevel"
```elm
formName : Player -> Html Msg
formName player =
  div [ class "clearfix py1" ] [
    div [ class "col col-5" ]
        [ text "Name" ]
  , div [ class "col col-7" ] [
      span [ class "h2 bold" ]
           [ text player.name ]
    , input [
        class "ml1 h1"
      , placeholder player.name
      , onInput ( Msgs.ChangeName player )
      ] []
    ]
  ]
```
([on "src/Players/Edit.elm"][edit])

### Show an error message when an Http request fails
- Add a field for error messages to Model and show it on Edit view
```elm
type alias Model = {
        players : WebData ( List Player )
    ,   route : Route
    ,   err : String
    }
```
[on "src/Models.elm"][model]
```elm
errValidation : Model -> Html Msg
errValidation model =
--let color =
--     = ( model.err == "Unchanged" ) => "gray"
--    |= ( model.err == "Changed Successfully" ) => "green"
--    |= "red"
  let color = colourValidation model
  in div [ class "clearfix m3" ] [
      div [ class "col col-5"
          , style [ ( "color", color ) ]
        ] [ text model.err ]
  ]
```
[on "src/Players/Edit.elm"][edit]

### Optimistic updates
- Add model update to and remove save Cmd from "Change" Msgs
- Add "saveBtn"
```elm
  Msgs.ChangeLevel player howMuch ->
    let updatedPlayer = { player | level = player.level + howMuch }
  --in ( model, savePlayerCmd Patch updatedPlayer )
    in ( updatePlayer model updatedPlayer, Cmd.none )
  Msgs.ChangeName player newName ->
    let updatedPlayer = { player | name = newName }
  --in ( model, savePlayerCmd Patch updatedPlayer )
    in ( updatePlayer model updatedPlayer, Cmd.none )
```
[on "src/Update.elm"][update]
```elm
saveBtn : Player -> Html Msg
saveBtn player =
  div [ class "clearfix mb2 black bg-white p1" ] [
    a [ class "btn regular"
      , href playersPath
      , onLinkClick ( SavePlayer Patch player )
      ] [
      --i [ class "fa fa-chevron-left mr1" ] [ ]
        i [ class "fa fa-chevron-right mr1" ] [ ]
      , text "Save"
      ]
    ]
```
[on "src/Player/Edit.elm"][edit]

### Validations
- Add "formValidation"
```elm
formValidation : Player -> Html Msg
formValidation player =
  let ( message, color )
     = ( player.name == "" ) =>
        ( "Name is empty", "red" )
    |=  ( "", "" )
  in div [ class "clearfix py1" ] [
      div [ class "col col-5"
          , style [ ( "color", color ) ]
          ] [ text message ]
    ]
```
[on "src/Player/Edit.elm"][edit]

### Add perks and bonuses
- Add a field for equipment as a Player status
- Make list of equipments with bonus strength
- Calculate strength and show it on List view
```elm
type alias Player = {
        id : PlayerId
    ,   name : String
    ,   level : Int
    ,   equip : String
    }
```
[on "src/Model.elm"][model]

```elm
type alias Equip = {
    name : String
  , bonus : Int
  }

listEquip : List Equip
listEquip = [
    Equip "" 0
  , Equip "Steel sword" 3
  , Equip "Silver sword" 7
  ]

formEquip : Player -> Html Msg
formEquip player =
  div [ class "clearfix py1" ] [
    div [ class "col col-5" ]
        [ text "Equipment" ]
  , div [ class "col col-7" ] [
      span [ class "h2 bold" ]
           [ text player.equip ]
  --, input [
  --    class "ml1 h1"
  --  , placeholder player.equip
  --  , onInput ( Msgs.ChangeEquip player )
  --  ] []
    , select [
        class "ml1 h2"
      , onInput ( Msgs.ChangeEquip player ) ]
      --  option [ value "" ] [ text "" ]
      --, option [ value "Steel sword" ] [ text "Steel sword" ]
      --  viewOption player ""
      --, viewOption player "Steel sword"
          ( List.map ( optionEquip player ) listEquip )
    ]
  ]
```
[on "src/Player/Edit.elm"][edit]

```elm
equipBonus : Player -> Int
equipBonus player =
  let pick equip =
        player.equip == equip.name
      maybeEquip =
            List.filter pick listEquip
        |>  List.head
  in case maybeEquip of
      Just equip -> equip.bonus
      Nothing -> 0

playerRow : List Player -> Player -> Html Msg
playerRow players player =
  let bonus = equipBonus player
      strength = player.level + bonus
  in tr [ ] [
        td [ ] [ text ( player.id ) ]
    ,   td [ ] [ text player.name ]
    ,   td [ ] [ text ( toString player.level ) ]
    ,   td [ ] [ text player.equip ]
    ,   td [ ] [ text ( toString bonus )]
    ,   td [ ] [ text ( toString strength )]
    ,   td [ ] [ editBtn player ]
    ,   td [ ] [ deleteBtn player ]
    ]
```
[on "src/Player/List.elm"][list]


Elm Tutorial:
https://www.elm-tutorial.org/en/


