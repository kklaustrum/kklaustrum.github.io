module Character exposing
    ( Character
    , initCharacter
    , addItem
    , applyEffects
    , getParam
    , inventoryList
    , updatePrevInventory
    , allParamsData
    , hasAtLeastItems
    , hasPickedUp
    , hasItem
    , hasParam
    )
import Dict exposing (Dict)
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
    case List.member itemId character.inventory of
        True -> character
        False -> { character | inventory = List.append character.inventory [itemId] }

applyEffects : Dict String Int -> Character -> Character
applyEffects effects character =
    { character | params = Dict.foldl updateParam character.params effects }

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

hasPickedUp : String -> Character -> Bool
hasPickedUp itemId char =
    List.member itemId char.prevInventory

updatePrevInventory : Character -> Character
updatePrevInventory character =
    { character | prevInventory = character.inventory }

hasAtLeastItems : Int -> Character -> Bool
hasAtLeastItems n char =
    List.length char.inventory >= n

hasItem : String -> Character -> Bool
hasItem itemId char =
    List.member itemId char.inventory

hasParam : String -> Int -> Character -> Bool
hasParam key minValue char =
    getParam key char >= minValue
