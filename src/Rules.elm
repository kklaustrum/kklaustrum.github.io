module Rules exposing 
    ( standardRules
    , evaluate
    , PageMode(..)
    , ExtraChoices
    , SecretContent
    )

import Set
import Dict exposing (Dict)
import Veil exposing (Page)
import World exposing (WorldState)
import Character exposing (Character)
import Items exposing (getItemFromPage, getItemById)
import Locale exposing (Locale)

type alias SecretContent =
    { title : Locale -> String
    , content : Locale -> String
    , choices : Locale -> List ( String, String )
    }

type PageMode
    = NormalPage ExtraChoices
    | SecretPage SecretContent
    | GameOverPage
    | PageNotFound String
    | ItemPickup String

type alias ExtraChoices = List (String, String)

type alias Rule =
    { id : String
    , evaluate : WorldState -> Character -> String -> Maybe PageMode
    }

type alias SecretDoor =
    { fromPage : String
    , toPage : String
    , label : String
    , condition : Character -> Bool
    , title : Locale -> String
    , content : Locale -> String
    , choices : Locale -> List (String, String)
    }

secretDoors : List SecretDoor
secretDoors =
    [ { fromPage = "start"
      , toPage = "secret"
      , label = "Secret Door"
      , condition = \char -> Character.hasAtLeastTwoItems char.inventory
      , title = \l -> l.someRoomHeader
      , content = \l -> l.someRoomTxt
      , choices = \l -> [ ( l.backToHomeLabel, "start" ) ]
      }
    , { fromPage = "roguelike"
      , toPage = "anothersecret"
      , label = "Hidden Passage"
      , condition = \char -> List.length char.inventory >= 3
      , title = \_ -> "Another Secret Room"
      , content = \_ -> "You found a hidden passage!"
      , choices = \_ -> [ ( "Go back", "roguelike" ) ]
      }
    ]

gameOverRule : Int -> Rule
gameOverRule threshold =
    { id = "gameOver"
    , evaluate = \world _ page ->
        if World.visitCount page world >= threshold 
           && not (Set.member page World.safePages)
        then Just GameOverPage
        else Nothing
    }

alreadyPickedUp : Character -> String -> Bool
alreadyPickedUp char itemId =
    List.member itemId char.prevInventory

itemName : String -> String
itemName itemId =
    Maybe.withDefault "???" (Maybe.map .name (getItemById itemId))

toPickupMode : Character -> String -> Maybe PageMode
toPickupMode char itemId =
    if alreadyPickedUp char itemId then Nothing
    else Just (ItemPickup (itemName itemId))

pickupRule : Rule
pickupRule =
    { id = "pickup"
    , evaluate = \_ char page ->
        getItemFromPage page
            |> Maybe.andThen (toPickupMode char)
    }

secretRule : Rule
secretRule =
    { id = "secret"
    , evaluate = \_ char page ->
        firstMatchingDoor secretDoors char page
    }

firstMatchingDoor : List SecretDoor -> Character -> String -> Maybe PageMode
firstMatchingDoor doors char page =
    case doors of
        [] ->
            Nothing

        door :: rest ->
            if door.toPage == page && door.condition char then
                Just (SecretPage { title = door.title, content = door.content, choices = door.choices })
            else if door.fromPage == page && door.condition char then
                Just (NormalPage [ ( door.label, door.toPage ) ])
            else
                firstMatchingDoor rest char page

standardRules : List Rule
standardRules = 
    [ secretRule
    , gameOverRule 3
    , pickupRule
    ]

-- Apply rules in order, return the result of the first one that matches
evaluate : List Rule -> WorldState -> Character -> String -> PageMode
evaluate rules world char page =
    let
        folder : Rule -> Maybe PageMode -> Maybe PageMode
        folder rule maybeMode =
            case maybeMode of
                Just mode -> Just mode
                Nothing -> rule.evaluate world char page
    in
    List.foldl folder Nothing rules
        |> Maybe.withDefault (NormalPage [])
