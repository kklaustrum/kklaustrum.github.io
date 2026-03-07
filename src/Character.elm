module Character exposing
    ( Character
    , initCharacter
    , addItem
    , applyItemEffects
    , getParam
    , inventoryList
    , visitPage
    , shouldShowPickup
    , updatePrevInventory
    , allParamsData
    , hasAtLeastTwoItems
    )

import Dict exposing (Dict)
import Items exposing (Item, getItemById, getItemEffects)
import Params exposing (Param(..), paramToString, defaultValues)
import Locale exposing (Locale, is, en, ru)

type alias Character =
    { inventory : List String
    , prevInventory : List String
    , params : Dict String Int
    }

type alias ParamConfig =
    { key : Param
    , default : Int
    , labelField : Locale -> String
    }

allParamsData : Character -> Dict String Int
allParamsData character = character.params

initParams : Dict String Int
initParams =
    Dict.fromList (List.map (\( param, value ) -> ( paramToString param, value )) Params.defaultValues)

initCharacter : Character
initCharacter =
    { inventory = []
    , prevInventory = []
    , params = initParams
    }

addItem : String -> Character -> Character
addItem itemId character =
    { character | inventory = Items.addToInventory itemId character.inventory }

applyItemEffects : String -> Character -> Character
applyItemEffects itemId character =
    let
        newParams =
            Items.getItemById itemId
                |> Maybe.map getItemEffects
                |> Maybe.map (Dict.foldl updateParam character.params)
                |> Maybe.withDefault character.params
    in
    { character | params = newParams }

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
    case Items.getItemFromPage pageId of
        Just itemId ->
            if shouldShowPickup character pageId then
                character 
                    |> updatePrevInventory 
                    |> addItem itemId 
                    |> applyItemEffects itemId
            else
                updatePrevInventory character
                
        Nothing ->
            updatePrevInventory character

shouldShowPickup : Character -> String -> Bool
shouldShowPickup character pageId =
    Items.getItemFromPage pageId
        |> Maybe.map (\itemId -> List.member itemId character.inventory |> not)
        |> Maybe.withDefault False

updatePrevInventory : Character -> Character
updatePrevInventory character =
    { character | prevInventory = character.inventory }

hasAtLeastTwoItems : List String -> Bool
hasAtLeastTwoItems inventory =
    List.length inventory >= 2
