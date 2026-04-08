module Utils exposing
    ( Config
    , defaultConfig
    , bookUrl
    , markdownUrl
    , isBookUrl
    , formatVisitPath
    , formatInventoryData, formatEquippedData, formatStashData
    , formatParamsData
    , formatItemPickup
    , debugData, joinList
    , maybeWhen, listWhen, itemAt
    )

import World exposing (WorldState, visitCount, visitPath)
import Dict exposing (Dict)
import Set exposing (Set)
import Locale exposing (Locale, is, en)
import String exposing (fromInt)
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
    label ++ helpers.space ++ open ++ content ++ close

emptyOrList : StringHelpers -> String -> String -> List String -> String
emptyOrList helpers label emptyText items =
    case items of
        [] -> label ++ helpers.space ++ emptyText
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

joinList : List String -> String
joinList items =
    String.join stringHelpers.listSep items

formatParamsData : Locale -> String
formatParamsData locale =
    locale.paramsLabel

formatInventoryData : Locale -> List String -> String
formatInventoryData locale items =
    case items of
        [] -> labelWithSeparator stringHelpers locale.inventoryLabel locale.noItemsLabel
        _ -> formatListWithBrackets stringHelpers locale.inventoryLabel items

formatEquippedData : Locale -> List String -> String
formatEquippedData locale items =
    emptyOrList stringHelpers (stringHelpers.space ++ stringHelpers.space) locale.noItemsLabel items

formatStashData : Locale -> List String -> String
formatStashData locale items =
    emptyOrList stringHelpers (stringHelpers.space ++ stringHelpers.space) locale.noItemsLabel items

formatItemPickup : Locale -> String -> String
formatItemPickup locale itemName =
    replaceLocalePlaceholder stringHelpers locale.itemPickedUp itemName

maybeWhen : Bool -> a -> Maybe a
maybeWhen condition value =
    case condition of
        True -> Just value
        False -> Nothing

listWhen : Bool -> a -> List a
listWhen condition value =
    case condition of
        True -> [ value ]
        False -> []

itemAt : Int -> List a -> Maybe a
itemAt n list =
    maybeWhen (n >= 0) list
        |> Maybe.andThen (List.drop n >> List.head)
