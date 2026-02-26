module Rules exposing 
    ( standardRules
    , evaluate
    , PageMode(..)
    , ExtraChoices
    )

import Set
import Dict exposing (Dict)
import Veil exposing (Page)
import World exposing (WorldState)
import Character exposing (Character)
import Items exposing (getItemFromPage)

type PageMode
    = NormalPage ExtraChoices
    | SecretPage ExtraChoices
    | GameOverPage
    | PageNotFound String
    | ItemPickup String

type alias ExtraChoices = List (String, String)

type alias Rule =
    { id : String
    , evaluate : WorldState -> Character -> String -> Maybe PageMode
    }

gameOverRule : Int -> Rule
gameOverRule threshold =
    { id = "gameOver"
    , evaluate = \world _ page ->
        if World.visitCount page world >= threshold 
           && not (Set.member page World.safePages)
        then Just GameOverPage
        else Nothing
    }

pickupRule : Rule
pickupRule = 
    { id = "pickup"
    , evaluate = \_ char page ->
        if List.any (\p -> p.pageId == page) Items.pickupPages then
            Items.getItemFromPage page
                |> Maybe.map (\item -> if List.member item char.prevInventory then Nothing else Just (ItemPickup item))
                |> Maybe.withDefault Nothing
        else
            Nothing
    }

secretRule : Rule
secretRule =
    { id = "secret"
    , evaluate = \_ char page ->
        case page of
            "secret" ->
                if Character.hasAtLeastTwoItems char.inventory then
                    Just (SecretPage [])
                else
                    Nothing
            "start" ->
                if Character.hasAtLeastTwoItems char.inventory then
                    Just (NormalPage [ ("Secret Door", "secret") ])
                else
                    Nothing
            _ ->
                Nothing
    }

standardRules : List Rule
standardRules = 
    [ secretRule
    , gameOverRule 3
    , pickupRule
    ]

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
