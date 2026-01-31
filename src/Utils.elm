module Utils exposing
    ( Config
    , defaultConfig
    , bookUrl
    , markdownUrl
    , isBookUrl
    , extraInfo
    , gameOverInfo
    )

import Html exposing (Html, p, text)
import World exposing (WorldState, visitCount, hasReachedThreshold)
import String exposing (fromInt)
import Locale exposing (Locale, is, en, ru)

type alias Config =
    { defaultLocale : Locale
    , bookUrl : String
    , markdownUrl : String
    , showDebugInfo : Bool
    }

defaultConfig : Config
defaultConfig =
    { defaultLocale = is
    , bookUrl = "./book.json"
    , markdownUrl = "./book.md"
    , showDebugInfo = False
    }

bookUrl : Config -> String
bookUrl cfg =
    cfg.bookUrl

markdownUrl : Config -> String
markdownUrl cfg =
    cfg.markdownUrl

isBookUrl : String -> Config -> Bool
isBookUrl url cfg =
    url == cfg.bookUrl

extraInfo config locale world currentPage =
    if config.showDebugInfo then
        [ p [] [ text (locale.debugCurrentPage currentPage (String.fromInt (World.visitCount currentPage world))) ] ]
    else
        []

gameOverInfo locale world currentPage =
    if World.hasReachedThreshold currentPage world then
        [ p [] [ text locale.gameOver ] ]
    else
        []
