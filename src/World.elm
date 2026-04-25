module World exposing
    ( initWorld, addVisitIfNew
    , visitCount, visitPath
    , startPage, safePages
    , isGameOverCandidate
    )

import Dict exposing (Dict)
import Set exposing (Set)
import Types exposing (WorldState)

startPage : String
startPage = "start"

safePages : Set String
safePages =
    Set.fromList [ "start", "todo" ]

initWorld : WorldState
initWorld =
    { visited = Set.empty
    , visitCounts = Dict.empty
    , visitHistory = []
    }

addVisit : String -> WorldState -> WorldState
addVisit pageId world =
    { world 
    | visited = Set.insert pageId world.visited
    , visitHistory = pageId :: world.visitHistory
    , visitCounts = updateContentCounts pageId world.visitCounts
    }

addVisitIfNew : String -> WorldState -> String -> WorldState
addVisitIfNew pageId world currentPage =
    case pageId == currentPage of
        True -> world
        False -> addVisit pageId world

updateContentCounts : String -> Dict String Int -> Dict String Int
updateContentCounts pageId counts =
    Dict.union (incrementPageCounter pageId counts |> filterContentPages) 
               (filterContentPages counts)

filterContentPages : Dict String Int -> Dict String Int
filterContentPages =
    Dict.filter (\key _ -> not <| Set.member key safePages)

incrementPageCounter : String -> Dict String Int -> Dict String Int
incrementPageCounter pageId counts =
    let
        oldCount = Dict.get pageId counts |> Maybe.withDefault 0
        newCount = oldCount + 1
    in
    Dict.singleton pageId newCount

visitCount : String -> WorldState -> Int
visitCount pageId world =
    Dict.get pageId world.visitCounts |> Maybe.withDefault 0

visitPath : WorldState -> List String
visitPath world =
    List.reverse world.visitHistory

isGameOverCandidate : String -> WorldState -> Int -> Bool
isGameOverCandidate page world threshold =
    visitCount page world >= threshold
        && not (Set.member page safePages)
