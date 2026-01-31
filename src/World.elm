module World exposing
    ( WorldState
    , initWorld
    , threshold
    , addVisit
    , visitCount
    , hasReachedThreshold
    )

import Dict exposing (Dict)
import Set exposing (Set)

threshold : Int
threshold =
    3

type alias WorldState =
    { visited : Set String
    , visitCounts : Dict String Int
    }

initWorld : WorldState
initWorld =
    { visited = Set.empty
    , visitCounts = Dict.empty
    }

addVisit : String -> WorldState -> WorldState
addVisit pageId world =
    let
        newVisited =
            Set.insert pageId world.visited

        oldCount =
            Dict.get pageId world.visitCounts
                |> Maybe.withDefault 0

        newCounts =
            Dict.insert pageId (oldCount + 1) world.visitCounts
    in
    { visited = newVisited
    , visitCounts = newCounts
    }

visitCount : String -> WorldState -> Int
visitCount pageId world =
    Dict.get pageId world.visitCounts
        |> Maybe.withDefault 0

hasReachedThreshold : String -> WorldState -> Bool
hasReachedThreshold pageId world =
    visitCount pageId world >= threshold
