module Shards exposing (all)

import Structure exposing (Passage, Route, passage, withCondition, withTitle, withBody, withTrait)
import Conditions exposing (Condition(..))
import Params exposing (Param(..))
import Traits exposing (Trait(..))
import Locale exposing (Locale)

secretEntrance : Locale -> Passage
secretEntrance locale =
    passage locale { from = "start", to = "secret", label = "H2" }
        |> withCondition (HasAtLeastItems 2)
        |> withTitle locale.someRoomHeader
        |> withBody locale.someRoomTxt

shardPassage : Locale -> Passage
shardPassage locale =
    passage locale { from = "roguelike", to = "shard", label = "E10" }
        |> withCondition (HasParam Endurance 10)
        |> withTitle locale.anotherRoomHeader
        |> withBody locale.anotherRoomTxt

all : Locale -> List Passage
all locale =
    [ secretEntrance locale
    , shardPassage locale
    ]
