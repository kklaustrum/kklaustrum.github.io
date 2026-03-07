module Utils exposing
    ( Config
    , defaultConfig
    , bookUrl
    , markdownUrl
    , isBookUrl
    , formatVisitPath
    , formatDebugInfoPure, formatInventoryData, formatParamsData, formatItemPickup
    , debugData  
    )

import Html exposing (Html, p, hr, text)
import Html.Attributes exposing (class)
import World exposing (WorldState, visitCount, visitPath)
import Dict exposing (Dict)
import Set exposing (Set)
import Locale exposing (Locale, is, en, ru)
import String exposing (fromInt)
import Messages exposing (Msg(..))
import Params exposing (stringToParam, getParamLabel)

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

debugData : WorldState -> String -> { currentPage : String, visits : Int, path : List String }
debugData world currentPage =
    { currentPage = currentPage
    , visits = World.visitCount currentPage world
    , path = World.visitPath world
    }

formatDebugInfoPure : Locale -> String -> Int -> List String -> String
formatDebugInfoPure locale currentPage visits path =
    let
        visitsText = replaceLocalePlaceholder stringHelpers locale.debugCurrentPageVisits (String.fromInt visits)
    in
    String.join " | " 
        [ labelWithSeparator stringHelpers locale.debugCurrentPagePrefix currentPage
        , visitsText
        , formatVisitPath locale path
        ]

formatParamsData : Locale -> Dict String Int -> String
formatParamsData locale paramsDict =
    let
        paramEntries = Dict.toList paramsDict
        paramStrings = List.map (formatParamEntry locale) paramEntries
        separatedParams = List.intersperse stringHelpers.listSep paramStrings
        paramsText = String.join "" separatedParams
    in
        labelWithSeparator stringHelpers locale.paramsLabel paramsText

formatParamEntry : Locale -> ( String, Int ) -> String
formatParamEntry locale ( key, value ) =
    let
        label =
            stringToParam key
                |> Maybe.map (Params.getParamLabel locale)
                |> Maybe.withDefault key
    in
    labelWithSeparator stringHelpers label (String.fromInt value)

formatInventoryData : Locale -> List String -> String
formatInventoryData locale items =
    case items of
        [] -> labelWithSeparator stringHelpers locale.inventoryLabel locale.noItemsLabel
        _ -> formatListWithBrackets stringHelpers locale.inventoryLabel items

formatItemPickup : Locale -> String -> String
formatItemPickup locale itemName =
    replaceLocalePlaceholder stringHelpers locale.itemPickedUp itemName
