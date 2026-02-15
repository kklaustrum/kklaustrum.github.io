module World exposing
    ( WorldState
    , initWorld, addVisit, addItem, applyItemEffects
    , visitCount, visitPath, hasReachedThreshold
    , getParam, inventoryList
    , threshold, safePages
    )

import Dict exposing (Dict)
import Set exposing (Set)
import Items exposing (defaultParams, Item, getItemById, getItemEffects, addToInventory)

threshold : Int
threshold =
    3

safePages : Set String
safePages =
    Set.fromList [ "start", "todo" ]

type alias WorldState =
    { visited : Set String
    , visitCounts : Dict String Int
    , visitHistory : List String
    , inventory : List String
    , params : Dict String Int
    }

initWorld : WorldState
initWorld =
    { visited = Set.empty
    , visitCounts = Dict.empty
    , visitHistory = []
    , inventory = []
    , params = Items.defaultParams
    }

addVisit : String -> WorldState -> WorldState
addVisit pageId world =
    { world 
    | visited = Set.insert pageId world.visited
    , visitHistory = pageId :: world.visitHistory
    , visitCounts = updateContentCounts pageId world.visitCounts
    }

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

hasReachedThreshold : String -> WorldState -> Bool
hasReachedThreshold pageId world =
    not (Set.member pageId safePages) && visitCount pageId world >= threshold

applyItemEffects : String -> WorldState -> WorldState
applyItemEffects itemId world =
    case Items.getItemById itemId of
        Just item ->
            let
                effects = Items.getItemEffects item
                updateParam k v =
                    Dict.get k world.params 
                        |> Maybe.withDefault 0 
                        |> (+) v
                newParams = Dict.map updateParam effects
            in
            { world | params = Dict.union newParams world.params }
        Nothing -> world

addItem : String -> WorldState -> WorldState
addItem itemId world =
    { world | inventory = Items.addToInventory itemId world.inventory }

getParam : String -> WorldState -> Int
getParam paramName world =
    Dict.get paramName world.params |> Maybe.withDefault 0

inventoryList : WorldState -> List String
inventoryList world = world.inventory
