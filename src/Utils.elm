module Utils exposing
    ( Config
    , defaultConfig
    , bookUrl
    , markdownUrl
    , isBookUrl
    , extraInfo
    , gameOverInfo
    , formatDebugInfo
    , formatVisitPath
    , formatParams
    , formatInventory
    )

import Html exposing (Html, p, hr, text)
import Html.Attributes exposing (class)
import World exposing (WorldState, visitCount, hasReachedThreshold, visitPath)
import Dict exposing (Dict)
import Set exposing (Set)
import Locale exposing (Locale, is, en, ru)
import String exposing (fromInt)

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

type alias StringHelpers =
    { separator : String
    , listSep : String  
    , space : String
    , placeholder : String
    , brackets : (String, String)
    }

stringHelpers : StringHelpers
stringHelpers =
    { separator = ": "
    , listSep = ", "
    , space = " "
    , placeholder = "%s"
    , brackets = ("[", "]")
    }

labelWithSeparator : StringHelpers -> String -> String -> String
labelWithSeparator helpers label value =
    label ++ helpers.separator ++ value

formatListWithBrackets : StringHelpers -> String -> List String -> String
formatListWithBrackets helpers label list =
    let
        (open, close) = helpers.brackets
        content = String.join helpers.listSep list
    in
    label ++ helpers.separator ++ open ++ content ++ close

emptyOrList : StringHelpers -> String -> String -> List String -> String
emptyOrList helpers label emptyText items =
    case items of
        [] -> labelWithSeparator helpers label emptyText
        _ -> formatListWithBrackets helpers label items

replaceLocalePlaceholder : StringHelpers -> String -> String -> String
replaceLocalePlaceholder helpers template replacement =
    String.replace helpers.placeholder replacement template

bookUrl : Config -> String
bookUrl cfg =
    cfg.bookUrl

markdownUrl : Config -> String
markdownUrl cfg =
    cfg.markdownUrl

isBookUrl : String -> Config -> Bool
isBookUrl url cfg =
    url == cfg.bookUrl

formatVisitPath : Locale -> List String -> String
formatVisitPath locale path =
    formatListWithBrackets stringHelpers locale.debugPathLabel path

formatParams : Locale -> WorldState -> String
formatParams locale world =
    let
        paramTranslations =
            [ ( "curiosity", locale.curiosity )
            , ( "endurance", locale.endurance )
            , ( "intellect", locale.intellect )
            ]
   
        paramStrings =
            paramTranslations
                |> List.map (\(key, label) -> 
                    let
                        value = Dict.get key world.params |> Maybe.withDefault 0
                    in
                        label ++ stringHelpers.space ++ String.fromInt value)
    in
    labelWithSeparator stringHelpers locale.paramsLabel 
        (String.join stringHelpers.listSep paramStrings)

formatInventory : Locale -> WorldState -> String
formatInventory locale world =
    let
        result = formatListWithBrackets stringHelpers locale.inventoryLabel world.inventory
    in
    result

formatDebugInfo : Locale -> WorldState -> String -> String
formatDebugInfo locale world currentPage =
    let
        visits = String.fromInt (visitCount currentPage world)
        pathText = formatVisitPath locale (visitPath world)
        visitsText = replaceLocalePlaceholder stringHelpers locale.debugCurrentPageVisits (stringHelpers.space ++ visits)
    in
    String.join " | " 
        [ locale.debugCurrentPagePrefix ++ stringHelpers.separator ++ currentPage
        , visitsText
        , pathText
        ]

extraInfo : Config -> Locale -> WorldState -> String -> List (Html msg)
extraInfo config locale world currentPage =
    case config.showDebugInfo of
        True ->
            [ hr [] []
            , p [] [ text (formatDebugInfo locale world currentPage) ]
            , p [] [ text (formatParams locale world) ]
            , p [] [ text (formatInventory locale world) ]
            ]
        False ->
            []

gameOverInfo : Locale -> WorldState -> String -> List (Html msg)
gameOverInfo locale world currentPage =
    case hasReachedThreshold currentPage world of
        True  -> [ p [] [ text locale.gameOver ] ]
        False -> []
