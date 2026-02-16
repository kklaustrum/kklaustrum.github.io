module Character exposing
    ( Character
    , initCharacter
    , addItem
    , applyItemEffects
    , getParam
    , inventoryList
    , visitPage
    )

import Dict exposing (Dict)
import Items exposing (Item, getItemById, getItemEffects)

type alias Character =
    { inventory : List String
    , params : Dict String Int
    }

initCharacter : Character
initCharacter =
    { inventory = []
    , params = Items.defaultParams
    }

addItem : String -> Character -> Character
addItem itemId character =
    { character | inventory = Items.addToInventory itemId character.inventory }

applyItemEffects : String -> Character -> Character
applyItemEffects itemId character =
    let
        withParams : Dict String Int -> Character
        withParams newParams = 
            { character | params = newParams }
    in
        Items.getItemById itemId
            |> Maybe.map getItemEffects
            |> Maybe.map (Dict.foldl updateParam character.params)
            |> Maybe.withDefault character.params
            |> withParams

updateParam : comparable -> Int -> Dict comparable Int -> Dict comparable Int
updateParam key delta params =
    case Dict.get key params of
        Just currentValue ->
            Dict.insert key (currentValue + delta) params

        Nothing ->
            Dict.insert key delta params

getParam : String -> Character -> Int
getParam paramName character =
    Dict.get paramName character.params |> Maybe.withDefault 0

inventoryList : Character -> List String
inventoryList character = character.inventory

visitPage : String -> Character -> Character
visitPage pageId character =
    Items.getItemFromPage pageId
        |> Maybe.map (\itemId -> 
            character
                |> addItem itemId
                |> applyItemEffects itemId)
        |> Maybe.withDefault character
