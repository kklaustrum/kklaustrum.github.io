module Types exposing
    ( PageMode(..)
    , ExtraChoices
    , PageContent, emptyPageContent
    , Rule
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
import Messages exposing (Msg(..))

type alias RenderContext =
    { config : Config
    , locale : Locale
    , world : WorldState
    , character : Character
    , currentPage : String
    , book : Book
    }

type alias LocaleString = Locale -> String

type alias LocaleChoices = Locale -> List ( String, String )

type alias ExtraChoices = List ( String, String )

type alias PageContent =
    { title : String
    , content : String
    , choices : ExtraChoices
    }

emptyPageContent : PageContent
emptyPageContent =
    { title = "", content = "", choices = [] }

type PageMode
    = NormalPage ExtraChoices
    | PassagePage PageContent
    | GameOverPage
    | PageNotFound String
    | ItemPickup String

type alias Rule =
    { id : String
    , evaluate : WorldState -> Character -> String -> Maybe PageMode
    }

type EquippedItems = EquippedItems (List (String, String, Msg))
type StashItems = StashItems (List (String, String, Msg))
