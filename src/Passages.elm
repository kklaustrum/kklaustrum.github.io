module Passages exposing (passageRule)

import Types exposing (Rule, Condition, PageMode(..), SecretContent, LocaleString, LocaleChoices)
import Character exposing (Character)
import Locale exposing (Locale)
import Conditions exposing (Condition(..), evaluate)
import Params exposing (Param(..))

type alias Passage =
    { fromPage : String
    , toPage : String
    , label : String
    , condition : Condition
    , title : LocaleString
    , content : LocaleString
    , choices : LocaleChoices
    }

passage : String -> String -> String -> Passage
passage from to label =
    { fromPage = from
    , toPage = to
    , label = label
    , condition = HasAtLeastItems 0
    , title = always ""
    , content = always ""
    , choices = always []
    }

withCondition : Condition -> Passage -> Passage
withCondition cond p =
    { p | condition = cond }

withContent : LocaleString -> LocaleString -> LocaleChoices -> Passage -> Passage
withContent title content choices p =
    { p | title = title, content = content, choices = choices }

backTo : String -> LocaleChoices
backTo page locale =
    [ ( locale.backToHomeLabel, page ) ]

passages : List Passage
passages =
    [ passage "start" "secret" "Secret Door"
        |> withCondition (HasAtLeastItems 2)
        |> withContent
            .someRoomHeader
            .someRoomTxt
            (backTo "start")

    , passage "roguelike" "anothersecret" "Hidden Passage"
        |> withCondition (HasParam Endurance 10)
        |> withContent
            (always "Another Secret Room")
            (always "You found a hidden passage!")
            (always [ ( "Go back", "roguelike" ) ])
    ]

toSecretContent : Passage -> SecretContent
toSecretContent p =
    { title = p.title
    , content = p.content
    , choices = p.choices
    }

isSecretEntry : Character -> String -> Passage -> Bool
isSecretEntry char page p =
    p.toPage == page && Conditions.evaluate p.condition char

isVisiblePassage : Character -> String -> Passage -> Bool
isVisiblePassage char page p =
    p.fromPage == page && Conditions.evaluate p.condition char

firstMatchingPassage : List Passage -> Character -> String -> Maybe PageMode
firstMatchingPassage ps char page =
    case ps of
        [] ->
            Nothing

        p :: rest ->
            let
                isSecret = isSecretEntry char page
                isVisible = isVisiblePassage char page
            in
            case ( isSecret p, isVisible p ) of
                ( True, _ ) ->
                    Just (SecretPage (toSecretContent p))

                ( _, True ) ->
                    Just (NormalPage [ ( p.label, p.toPage ) ])

                _ ->
                    firstMatchingPassage rest char page

passageRule : Rule
passageRule =
    { id = "passage"
    , evaluate = \_ char page ->
        firstMatchingPassage passages char page
    }
