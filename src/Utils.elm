module Utils exposing
    ( Config
    , defaultConfig
    , bookUrl
    , markdownUrl
    , isBookUrl
    , extraInfo
    , gameOverInfo
    )

import Html exposing (Html, p, hr, text)
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
    , bookUrl = "/res/book.json"
    , markdownUrl = "/res/book.md"
    , showDebugInfo = True
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

formatVisitPath : List String -> String
formatVisitPath path = 
    "[ " ++ String.join ", " path ++ " ]"

formatDebugInfo : Locale -> WorldState -> String -> String
formatDebugInfo locale world currentPage =
    let
        visits = String.fromInt (World.visitCount currentPage world)
        pathText = formatVisitPath (World.visitPath world)
    in
    String.join " | " 
        [ locale.debugCurrentPagePrefix ++ ": " ++ currentPage
        , locale.debugCurrentPageVisits |> String.replace "%s" (" " ++ visits)
        , locale.debugPathLabel ++ ": " ++ pathText
        ]

extraInfo : Config -> Locale -> WorldState -> String -> List (Html msg)
extraInfo config locale world currentPage =
    case config.showDebugInfo of
        True ->
            [ hr [] []
            , p [] [ text (formatDebugInfo locale world currentPage) ]
            ]

        False ->
            []

gameOverInfo : Locale -> WorldState -> String -> List (Html msg)
gameOverInfo locale world currentPage =
    case World.hasReachedThreshold currentPage world of
        True  -> [ p [] [ text locale.gameOver ] ]
        False -> []
