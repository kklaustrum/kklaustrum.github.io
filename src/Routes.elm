module Routes exposing (all, dungeonRoute)

import Structure exposing (Passage, Route, passage, withCondition, withTitle, withBody, withTrait, withRoute)
import Conditions exposing (Condition(..))
import Params exposing (Param(..))
import Traits exposing (Trait(..))
import Locale exposing (Locale)

dungeonRoute : Route
dungeonRoute =
    { id = "dungeon"
    , pages = [ "roguelike", "step", "dungeon" ]
    , nextLabel = \locale -> locale.goDeeperLabel
    , backLabel = \locale -> locale.backToHomeLabel
    }

deeperPassage : Locale -> Passage
deeperPassage locale =
    passage locale { from = "roguelike", to = "step", label = "will be replaced" }
        |> withRoute dungeonRoute
        |> withCondition (HasParam Curiosity 6)
        |> withTitle locale.goingDeeperHeader
        |> withBody locale.goingDeeperTxt

dungeonPassage : Locale -> Passage
dungeonPassage locale =
    passage locale { from = "step", to = "dungeon", label = "С6" }
        |> withRoute dungeonRoute
        |> withCondition (HasParam Curiosity 6)
        |> withTrait Foobar

all : Locale -> List Passage
all locale =
    [ deeperPassage locale
    , dungeonPassage locale
    ]
