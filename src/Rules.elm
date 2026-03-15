module Rules exposing 
    ( standardRules
    , evaluate
    )

import Dict exposing (Dict)
import Veil exposing (Page)
import World exposing (WorldState)
import Character exposing (Character, hasPickedUp, hasAtLeastItems)
import Items exposing (getItemFromPage, getItemName)
import Locale exposing (Locale)
import Passages exposing (passageRule)
import Types exposing (Rule, PageMode(..), LocaleString, LocaleChoices)

gameOverRule : Int -> Rule
gameOverRule threshold =
    { id = "gameOver"
    , evaluate = \world _ page ->
        if World.isGameOverCandidate page world threshold
        then Just GameOverPage
        else Nothing
    }

toPickupMode : Character -> String -> Maybe PageMode
toPickupMode char itemId =
    if Character.hasPickedUp itemId char then
        Nothing
    else
        Just (ItemPickup (Items.getItemName itemId))

pickupRule : Rule
pickupRule =
    { id = "pickup"
    , evaluate = \_ char page ->
        Items.getItemFromPage page
            |> Maybe.andThen (toPickupMode char)
    }

standardRules : Locale -> List Rule
standardRules locale =
    [ Passages.passageRule locale
    , gameOverRule 5
    , pickupRule
    ]

-- Apply rules in order, return the result of the first one that matches
evaluate : List Rule -> WorldState -> Character -> String -> PageMode
evaluate rules world char page =
    let
        folder rule maybeMode =
            case maybeMode of
                Just mode -> Just mode
                Nothing -> rule.evaluate world char page
    in
    List.foldl folder Nothing rules
        |> Maybe.withDefault (NormalPage [])
