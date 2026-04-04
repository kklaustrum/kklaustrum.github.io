module Traits exposing
    ( Trait(..), traitToString, stringToTrait
    --, getTraitLabel
    , defaultTraits
    )

import Locale exposing (Locale)

type Trait
    = Lorem
    | Ipsum
    | Foobar

traitToString : Trait -> String
traitToString trait =
    case trait of
        Lorem -> "lorem"
        Ipsum -> "ipsum"
        Foobar -> "foobar"

stringToTrait : String -> Maybe Trait
stringToTrait s =
    case s of
        "lorem" -> Just Lorem
        "ipsum" -> Just Ipsum
        "foobar" -> Just Foobar
        _ -> Nothing

--getTraitLabel : Locale -> Trait -> String
--getTraitLabel locale trait =
    --case trait of
        --Lorem -> locale.traitLorem
        --Ipsum -> locale.traitIpsum
        --Foobar -> locale.traitFoobar

defaultTraits : List Trait
defaultTraits = []
