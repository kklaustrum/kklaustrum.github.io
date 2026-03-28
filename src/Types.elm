module Types exposing
    ( PageMode(..)
    , ExtraChoices
    , SecretContent
    , Rule
    , Condition
    , LocaleString
    , LocaleChoices
    , RenderContext
    , EquippedItems(..), StashItems(..)
    )

import Locale exposing (Locale)
import World exposing (WorldState)
import Character exposing (Character)
import Utils exposing (Config)
import Veil exposing (Book)
import Locale exposing (Locale)
import Messages exposing (Msg(..))

type alias RenderContext =
    { config : Config
    , locale : Locale
    , world : WorldState
    , character : Character
    , currentPage : String
    , pendingItem : Maybe String
    , book : Book
    , itemHint : Locale -> String -> String
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

type EquippedItems = EquippedItems (List (String, String, Msg))
type StashItems = StashItems (List (String, String, Msg))
