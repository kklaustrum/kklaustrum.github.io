module Types exposing
    ( PageMode(..)
    , ExtraChoices
    , Page, PageContent
    , Rule
    , LocaleString
    , LocaleChoices
    , UIContext, GameContext
    , ItemAction, EquippedItems(..), StashItems(..)
    , ScreenMode(..)
    , DebugInfo, Character, WorldState
    )

import Dict exposing (Dict)
import Set exposing (Set)
import Locale exposing (Locale)
import Utils exposing (Config)
import Veil exposing (Book)
import Messages exposing (Msg(..))
import Traits exposing (Trait(..))

type alias DebugInfo =
    { currentPage : String
    , visits      : Int
    , path        : List String
    }

type alias Character =
    { stash    : List String
    , equipped : List String
    , prevAll  : List String
    , params   : Dict String Int
    , traits   : List Trait
    }

type alias WorldState =
    { visited : Set String
    , visitCounts : Dict String Int
    , visitHistory : List String
    }

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
