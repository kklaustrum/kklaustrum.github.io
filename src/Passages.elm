module Passages exposing (passageRule)

import Dict
import Utils exposing (maybeWhen, itemAt)
import Types exposing (Rule, PageMode(..), PageContent, ExtraChoices, LocaleString, emptyPageContent)
import Character exposing (Character)
import Locale exposing (Locale)
import Conditions exposing (Condition(..), evaluate)
import Params exposing (Param(..))
import Traits exposing (Trait(..))

type alias Passage =
    { fromPage   : String
    , toPage     : String
    , label      : String
    , condition  : Condition
    , grantTrait : Maybe Trait
    , secret     : Maybe PageContent
    , route      : Maybe Route
    }

type alias PassageArgs =
    { from  : String
    , to    : String
    , label : String
    }

type alias Route =
    { id    : String
    , pages : List String
    , nextLabel : LocaleString
    , backLabel : LocaleString
    }

dungeonRoute : Route
dungeonRoute =
    { id    = "dungeon"
    , pages = [ "roguelike", "step", "dungeon" ]
    , nextLabel = \locale -> locale.goDeeperLabel
    , backLabel = \locale -> locale.backToHomeLabel
    }

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

        prev = index |> Maybe.andThen (\i -> itemAt (i - 1) pages)
        next = index |> Maybe.andThen (\i -> itemAt (i + 1) pages)
    in
    List.filterMap identity
        [ Maybe.map (\p -> ( route.backLabel locale, p )) prev
        , Maybe.map (\p -> ( route.nextLabel locale, p )) next
        ]

passage : Locale -> PassageArgs -> Passage
passage locale args =
    { fromPage   = args.from
    , toPage     = args.to
    , label      = args.label
    , condition  = Always
    , grantTrait = Nothing
    , route      = Nothing
    , secret     = Just { title = "", content = "", choices = backTo locale args.from }
    }

withCondition : Condition -> Passage -> Passage
withCondition cond p =
    { p | condition = cond }

emptySecret : PageContent
emptySecret =
    { title = "", content = "", choices = [] }

withTitle : String -> Passage -> Passage
withTitle title p =
    let secret = Maybe.withDefault emptySecret p.secret
    in { p | secret = Just { secret | title = title } }

withBody : String -> Passage -> Passage
withBody body p =
    let secret = Maybe.withDefault emptySecret p.secret
    in { p | secret = Just { secret | content = body } }

withTrait : Trait -> Passage -> Passage
withTrait trait p =
    { p | grantTrait = Just trait }

withRoute : Route -> Passage -> Passage
withRoute route p =
    { p | route = Just route }

backTo : Locale -> String -> ExtraChoices
backTo locale page =
    [ ( locale.backToHomeLabel, page ) ]

secretEntrance : Locale -> Passage
secretEntrance locale =
    passage locale { from = "start", to = "secret", label = "Secret Door" }
        |> withCondition (HasAtLeastItems 2)
        |> withTitle locale.someRoomHeader
        |> withBody locale.someRoomTxt

offstagePassage : Locale -> Passage
offstagePassage locale =
    passage locale { from = "roguelike", to = "anothersecret", label = "E10" }
        |> withCondition (HasParam Endurance 10)
        |> withTitle "Another Secret Room"
        |> withBody "You found a hidden passage!"

deeperPassage : Locale -> Passage
deeperPassage locale =
    passage locale { from = "roguelike", to = "step", label = "Deeper" }
        |> withRoute dungeonRoute
        |> withCondition (HasParam Curiosity 6)
        |> withTitle "Going deeper"
        |> withBody "Sort of."

dungeonPassage : Locale -> Passage
dungeonPassage locale =
    passage locale { from = "step", to = "dungeon", label = "С6" }
        |> withRoute dungeonRoute
        |> withCondition (HasParam Curiosity 6)
        |> withTrait Foobar

passages : Locale -> List Passage
passages locale =
    [ secretEntrance locale
    , offstagePassage locale
    , deeperPassage locale
    , dungeonPassage locale
    ]

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
