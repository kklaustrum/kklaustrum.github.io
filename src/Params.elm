module Params exposing
    ( Param(..)
    , paramToString
    , stringToParam
    , getParamLabel
    , defaultValues
    )

import Locale exposing (Locale)

type Param
    = Curiosity
    | Endurance
    | Intellect

paramToString : Param -> String
paramToString param =
    case param of
        Curiosity -> "curiosity"
        Endurance -> "endurance"
        Intellect -> "intellect"

stringToParam : String -> Maybe Param
stringToParam s =
    case s of
        "curiosity" -> Just Curiosity
        "endurance" -> Just Endurance
        "intellect" -> Just Intellect
        _ -> Nothing

getParamLabel : Locale -> Param -> String
getParamLabel locale param =
    case param of
        Curiosity -> locale.curiosity
        Endurance -> locale.endurance
        Intellect -> locale.intellect

defaultValues : List ( Param, Int )
defaultValues =
    [ ( Curiosity, 5 )
    , ( Endurance, 7 )
    , ( Intellect, 9 )
    ]
