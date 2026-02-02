module World exposing
    ( WorldState
    , initWorld
    , threshold
    , addVisit
    , visitCount
    , visitPath
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
    , visitHistory : List String
    }

initWorld : WorldState
initWorld =
    { visited = Set.empty
    , visitCounts = Dict.empty
    , visitHistory = []
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

        newHistory =
            pageId :: world.visitHistory
    in
    { visited = newVisited
    , visitCounts = newCounts
    , visitHistory = newHistory
    }

visitCount : String -> WorldState -> Int
visitCount pageId world =
    Dict.get pageId world.visitCounts
        |> Maybe.withDefault 0

visitPath : WorldState -> List String
visitPath world =
    List.reverse world.visitHistory

hasReachedThreshold : String -> WorldState -> Bool
hasReachedThreshold pageId world =
    visitCount pageId world >= threshold
