module Types exposing
    ( PageMode(..)
    , ExtraChoices
    , SecretContent
    , Rule
    , Condition
    , LocaleString
    , LocaleChoices
    )

import Locale exposing (Locale)
import World exposing (WorldState)
import Character exposing (Character)

type alias LocaleString = Locale -> String

type alias LocaleChoices = Locale -> List ( String, String )

type alias ExtraChoices = List ( String, String )

type alias SecretContent =
    { title : LocaleString
    , content : LocaleString
    , choices : LocaleChoices
    }

type PageMode
    = NormalPage ExtraChoices
    | SecretPage SecretContent
    | GameOverPage
    | PageNotFound String
    | ItemPickup String

type alias Rule =
    { id : String
    , evaluate : WorldState -> Character -> String -> Maybe PageMode
    }

type alias Condition = Character -> Bool
