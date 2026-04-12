module Types exposing
    ( PageMode(..)
    , ExtraChoices
    , Page, PageContent, emptyPageContent
    , Rule
    , LocaleString
    , LocaleChoices
    , UIContext, GameContext, CharacterContext
    , ItemAction, EquippedItems(..), StashItems(..)
    , ScreenMode(..)
    )

import Dict exposing (Dict)
import Locale exposing (Locale)
import World exposing (WorldState)
import Character exposing (Character)
import Utils exposing (Config)
import Veil exposing (Book)
import Messages exposing (Msg(..))
import Traits exposing (Trait(..))

type alias UIContext =
    { config : Config
    , locale : Locale
    , screen : ScreenMode
    }

type alias GameContext =
    { currentPage : String
    , world       : WorldState
    , book        : Book
    }

type alias CharacterContext =
    { stash    : List String
    , equipped : List String
    , params   : Dict String Int
    , traits   : List Trait
    }

type alias LocaleString = Locale -> String

type alias LocaleChoices = Locale -> List ( String, String )

type alias ExtraChoices = List ( String, String )

type alias PageContent =
    { title : String
    , content : String
    , choices : ExtraChoices
    }

type alias Page =
    { title : String
    , content : List String
    , choices : List ( String, String )
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

type alias ItemAction =
    { id     : String
    , hint   : String
    , action : Msg
    }

type EquippedItems = EquippedItems (List ItemAction)
type StashItems = StashItems (List ItemAction)

type ScreenMode
    = GameScreen
    | CharacterScreen
