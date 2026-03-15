module Passages exposing (passageRule)

import Types exposing (Rule, Condition, PageMode(..), SecretContent, LocaleChoices, ExtraChoices)
import Character exposing (Character)
import Locale exposing (Locale)
import Conditions exposing (Condition(..), evaluate)
import Params exposing (Param(..))

type alias Passage =
    { fromPage : String
    , toPage : String
    , label : String
    , condition : Condition
    , title : String
    , content : String
    , choices : ExtraChoices
    }

passage : Locale -> { from : String, to : String, label : String } -> Passage
passage locale args =
    { fromPage = args.from
    , toPage = args.to
    , label = args.label
    , condition = HasAtLeastItems 0
    , title = ""
    , content = ""
    , choices = backTo locale args.from
    }

withCondition : Condition -> Passage -> Passage
withCondition cond p =
    { p | condition = cond }

withTitle : String -> Passage -> Passage
withTitle title p =
    { p | title = title }

withBody : String -> Passage -> Passage
withBody content p =
    { p | content = content }

backTo : Locale -> String -> ExtraChoices
backTo locale page =
    [ ( locale.backToHomeLabel, page ) ]

secretEntrance : Locale -> Passage
secretEntrance locale =
    passage locale { from = "start", to = "secret", label = "Secret Door" }
        |> withCondition (HasAtLeastItems 2)
        |> withTitle locale.someRoomHeader
        |> withBody locale.someRoomTxt

hiddenPassage : Locale -> Passage
hiddenPassage locale =
    passage locale { from = "roguelike", to = "anothersecret", label = "E10" }
        |> withCondition (HasParam Endurance 10)
        |> withTitle "Another Secret Room"
        |> withBody "You found a hidden passage!"

testPassage : Locale -> Passage
testPassage locale =
    passage locale { from = "roguelike", to = "thirdsecret", label = "С6" }
        |> withCondition (HasParam Curiosity 6)
        |> withTitle locale.someRoomHeader
        |> withBody locale.someRoomTxt

passages : Locale -> List Passage
passages locale =
    [ secretEntrance locale
    , hiddenPassage locale
    , testPassage locale
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

collectPassages : List Passage -> Character -> String -> Maybe PageMode
collectPassages ps char page =
    let
        isSecret = isSecretEntry char page
        isVisible = isVisiblePassage char page

        secretPage =
            ps
                |> List.filter isSecret
                |> List.head
                |> Maybe.map (SecretPage << toSecretContent)

        extraChoices =
            ps
                |> List.filter isVisible
                |> List.map (\p -> ( p.label, p.toPage ))
    in
    case ( secretPage, extraChoices ) of
        ( Just secret, _ ) ->
            Just secret

        ( Nothing, [] ) ->
            Nothing

        ( Nothing, choices ) ->
            Just (NormalPage choices)

passageRule : Locale -> Rule
passageRule locale =
    { id = "passage"
    , evaluate = \_ char page ->
        collectPassages (passages locale) char page
    }
