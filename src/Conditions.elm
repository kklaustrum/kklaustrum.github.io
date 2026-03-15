module Conditions exposing (Condition(..), evaluate)

import Params exposing (Param(..), paramToString)
import Character exposing (Character, hasAtLeastItems, hasItem, hasParam)

type Condition
    = HasAtLeastItems Int
    | HasItem String
    | HasParam Param Int

evaluate : Condition -> Character -> Bool
evaluate condition char =
    case condition of
        HasAtLeastItems n ->
            hasAtLeastItems n char

        HasItem itemId ->
            hasItem itemId char

        HasParam param minValue ->
            Character.hasParam (paramToString param) minValue char
