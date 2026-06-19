module Passages exposing (passageRule, traitsForPage, passages, routeChoices)

import Structure exposing (Passage, Route, emptyPageContent)
import Routes
import Shards
import Utils exposing (itemAt)
import Types exposing (Character, Rule, PageMode(..), PageContent, ExtraChoices, LocaleString)
import Locale exposing (Locale)
import Conditions exposing (Condition(..), evaluate)
import Params exposing (Param(..))
import Traits exposing (Trait(..))

traitsForPage : String -> List Trait
traitsForPage pageId =
    passages Locale.is
        |> List.filter (\p -> p.toPage == pageId)
        |> List.filterMap .grantTrait

indexOf : a -> List a -> Maybe Int
indexOf target list =
    list
        |> List.indexedMap (\i x -> ( i, x ))
        |> List.filter (\( _, x ) -> x == target)
        |> List.head
        |> Maybe.map Tuple.first

routeChoices : Route -> String -> Locale -> ExtraChoices
routeChoices route fromPage locale =
    let
        pages = route.pages
        index = indexOf fromPage pages

        prev = index |> Maybe.andThen (\i -> Utils.itemAt (i - 1) pages)
        next = index |> Maybe.andThen (\i -> Utils.itemAt (i + 1) pages)
    in
    List.filterMap identity
        [ Maybe.map (\p -> ( route.backLabel locale, p )) prev
        , Maybe.map (\p -> ( route.nextLabel locale, p )) next
        ]

withCondition : Condition -> Passage -> Passage
withCondition cond p =
    { p | condition = cond }

passages : Locale -> List Passage
passages locale =
    Shards.all locale ++ Routes.all locale

isVisiblePassage : Character -> String -> Passage -> Bool
isVisiblePassage char page p =
    p.fromPage == page && Conditions.evaluate p.condition char

type alias DedupeState =
    ( List String, ExtraChoices )

addIfUnseen : ( String, String ) -> DedupeState -> DedupeState
addIfUnseen ( label, dest ) ( seen, acc ) =
    case List.member dest seen of
        True  -> ( seen, acc )
        False -> ( dest :: seen, acc ++ [ ( label, dest ) ] )

uniqueByDestination : ExtraChoices -> ExtraChoices
uniqueByDestination choices =
    choices
        |> List.foldl addIfUnseen ( [], [] )
        |> Tuple.second

toRouteNavigation : Locale -> Passage -> Maybe ExtraChoices
toRouteNavigation locale p =
    p.route |> Maybe.map (\route -> routeChoices route p.fromPage locale)

collectPassages : List Passage -> Character -> String -> Locale -> Maybe PageMode
collectPassages ps char page locale =
    let
        visiblePassages =
            ps |> List.filter (isVisiblePassage char page)

        extraChoices =
            visiblePassages
                |> List.filter (\p -> p.route == Nothing)
                |> List.map (\p -> ( p.label, p.toPage ))

        routeNavigation =
            visiblePassages
                |> List.filterMap (toRouteNavigation locale)
                |> List.concat
                |> uniqueByDestination

        autoBack =
            ps
                |> List.filter (\p -> p.toPage == page)
                |> List.head
                |> Maybe.map (\p -> ( locale.backToHomeLabel, p.fromPage ))
                |> Maybe.map List.singleton
                |> Maybe.withDefault []

        allChoices =
            case extraChoices ++ routeNavigation of
                [] -> autoBack
                choices -> choices
        pageOverride =
            ps
                |> List.filter (\p -> p.toPage == page)
                |> List.filterMap (\p -> p.secret)
                |> List.filter (\s -> s.title /= "" || s.content /= "")
                |> List.head

        pageContent =
            pageOverride
                |> Maybe.withDefault emptyPageContent
                |> (\pc -> { pc | choices = allChoices })

    in
    case ( pageOverride, allChoices ) of
        ( Nothing, [] ) -> Nothing
        ( Nothing, _  ) -> Just (NormalPage allChoices)
        ( Just _,  _  ) -> Just (PassagePage pageContent)

passageRule : Locale -> Rule
passageRule locale =
    { id = "passage"
    , evaluate = \_ char page ->
        collectPassages (passages locale) char page locale
    }
