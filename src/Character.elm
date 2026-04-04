module Character exposing
    ( Character
    , initCharacter
    , addToStash, moveToStash, moveToEquipped
    , equipItem
    , applyEffects, removeEffects
    , getParam
    , updatePrevInventory
    , hasAtLeastItems
    , hasPickedUp
    , hasItem
    , hasParam
    , addTrait
    )

import Dict exposing (Dict)
import Params exposing (Param(..), paramToString, defaultValues)
import Traits exposing (Trait(..), defaultTraits)

type alias Character =
    { stash    : List String
    , equipped : List String
    , prevAll  : List String
    , params   : Dict String Int
    , traits   : List Trait
    }

initParams : Dict String Int
initParams =
    Dict.fromList (List.map (\( param, value ) -> ( paramToString param, value )) Params.defaultValues)

initCharacter : Character
initCharacter =
    { stash    = []
    , equipped = []
    , prevAll  = []
    , params   = initParams
    , traits = Traits.defaultTraits
    }

allItems : Character -> List String
allItems character =
    character.stash ++ character.equipped

addToStash : String -> Character -> Character
addToStash itemId character =
    case List.member itemId (allItems character) of
        True  -> character
        False -> { character | stash = character.stash ++ [ itemId ] }

moveToStash : String -> Character -> Character
moveToStash itemId character =
    { character
        | equipped = List.filter (\id -> id /= itemId) character.equipped
        , stash    = character.stash ++ [ itemId ]
    }

moveToEquipped : String -> Character -> Character
moveToEquipped itemId character =
    { character
        | stash    = List.filter (\id -> id /= itemId) character.stash
        , equipped = character.equipped ++ [ itemId ]
    }

equipItem : String -> Character -> Character
equipItem itemId character =
    case List.member itemId (allItems character) of
        True  -> character
        False -> { character | equipped = character.equipped ++ [ itemId ] }

applyEffects : Dict String Int -> Character -> Character
applyEffects effects character =
    { character | params = Dict.foldl updateParam character.params effects }

removeEffects : Dict String Int -> Character -> Character
removeEffects effects character =
    let
        negated = Dict.map (\_ v -> -v) effects
    in
    { character | params = Dict.foldl updateParam character.params negated }

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

hasPickedUp : String -> Character -> Bool
hasPickedUp itemId char =
    List.member itemId char.prevAll

updatePrevInventory : Character -> Character
updatePrevInventory character =
    { character | prevAll = allItems character }

hasAtLeastItems : Int -> Character -> Bool
hasAtLeastItems n character =
    List.length (allItems character) >= n

hasItem : String -> Character -> Bool
hasItem itemId character =
    List.member itemId (allItems character)

hasParam : Param -> Int -> Character -> Bool
hasParam param minValue character =
    getParam (paramToString param) character >= minValue

addTrait : Trait -> Character -> Character
addTrait trait character =
    case List.member trait character.traits of
        True  -> character
        False -> { character | traits = character.traits ++ [ trait ] }
