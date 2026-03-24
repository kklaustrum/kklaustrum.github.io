module Types exposing
    ( PageMode(..)
    , ExtraChoices
    , SecretContent
    , Rule
    , Condition
    , LocaleString
    , LocaleChoices
    , RenderContext
    )

import Locale exposing (Locale)
import World exposing (WorldState)
import Character exposing (Character)
import Utils exposing (Config)
import Veil exposing (Book)

type alias RenderContext =
    { config : Config
    , locale : Locale
    , world : WorldState
    , character : Character
    , currentPage : String
    , pendingItem : Maybe String
    , book : Book
    }

type alias LocaleString = Locale -> String

type alias LocaleChoices = Locale -> List ( String, String )

type alias ExtraChoices = List ( String, String )

type alias SecretContent =
    { title : String
    , content : String
    , choices : ExtraChoices
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
