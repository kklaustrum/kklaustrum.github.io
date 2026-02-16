module Items exposing
    ( Item
    , PageItem
    , defaultParams
    , availableItems
    , pickupPages
    , getItemFromPage
    , getItemById
    , getItemEffects
    , addToInventory
    )

import Dict exposing (Dict)

type alias PageItem =
    { pageId : String
    , itemId : String
    }

type alias Item =
    { name : String
    , buffs : Dict String Int
    , penalties : Dict String Int
    }

defaultParams : Dict String Int
defaultParams = Dict.fromList [ ("curiosity", 5), ("endurance", 10), ("intellect", 8) ]

firstItem : Item
firstItem = 
    { name = "firstItem"
    , buffs = Dict.fromList [ ("endurance", 1) ]
    , penalties = Dict.empty
    }

secondItem : Item
secondItem = 
    { name = "secondItem"
    , buffs = Dict.fromList [ ("endurance", 3) ]
    , penalties = Dict.fromList [ ("curiosity", 2) ]
    }

thirdItem : Item
thirdItem = 
    { name = "thirdItem"
    , buffs = Dict.fromList [ ("intellect", 1) ]
    , penalties = Dict.empty
    }

availableItems : List Item
availableItems = [ firstItem, secondItem, thirdItem ]

pickupPages : List PageItem
pickupPages =
    [ { pageId = "mint", itemId = "firstItem" }
    , { pageId = "ux", itemId = "secondItem" }
    , { pageId = "unwritten", itemId = "thirdItem" }
    ]

pageDict : Dict String PageItem
pageDict = Dict.fromList (List.map (\p -> (p.pageId, p)) pickupPages)

getItemFromPage : String -> Maybe String
getItemFromPage pageId = Dict.get pageId pageDict |> Maybe.map .itemId

getItemById : String -> Maybe Item
getItemById itemId =
    List.filter (\item -> item.name == itemId) availableItems
        |> List.head

negatePenalty : a -> Int -> Int
negatePenalty _ value = 
    negate value

getItemEffects : Item -> Dict String Int
getItemEffects item =
    Dict.union item.buffs 
        (Dict.map negatePenalty item.penalties)

addToInventory : String -> List String -> List String
addToInventory itemId inventory =
    case List.member itemId inventory of
        True -> inventory
        False -> List.append inventory [itemId] 
