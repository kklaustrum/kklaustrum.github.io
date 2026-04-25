module Conditions exposing (Condition(..), evaluate)

import Params exposing (Param(..), paramToString)
import Character exposing (hasAtLeastItems, hasItem, hasParam)
import Traits exposing (Trait)
import Types exposing (Character)

type Condition
    = Always
    | HasAtLeastItems Int
    | HasItem String
    | HasParam Param Int
    | HasTrait Trait

evaluate : Condition -> Character -> Bool
evaluate condition char =
    case condition of
        Always -> True
        HasAtLeastItems n ->
            hasAtLeastItems n char

        HasItem itemId ->
            hasItem itemId char

        HasParam param minValue ->
            Character.hasParam param minValue char

        HasTrait trait ->
            List.member trait char.traits
