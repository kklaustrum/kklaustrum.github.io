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
    , getParamLabel
    , hasAtLeastTwoItems
    )

import Dict exposing (Dict)
import Items exposing (Item, getItemById, getItemEffects)
import Locale exposing (Locale, is, en, ru)

type alias Character =
    { inventory : List String
    , prevInventory : List String
    , params : Dict String Int
    }

type alias ParamConfig =
    { key : String
    , default : Int
    , labelField : Locale -> String
    }

allParams : List ParamConfig
allParams =
    [ { key = "curiosity", default = 5, labelField = \l -> l.curiosity }
    , { key = "endurance", default = 7, labelField = \l -> l.endurance }
    , { key = "intellect", default = 9, labelField = \l -> l.intellect }
    ]

allParamsData : Character -> Dict String Int
allParamsData character = character.params

initParams : Dict String Int
initParams =
    Dict.fromList (List.map (\p -> (p.key, p.default)) allParams)

getParamLabel : Locale -> String -> String
getParamLabel locale key =
    List.filter (\p -> p.key == key) allParams
        |> List.head
        |> Maybe.map (\config -> config.labelField locale)
        |> Maybe.withDefault key

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
