module Items exposing
    ( Item
    , PageItem
    , availableItems
    , pickupPages
    , getItemFromPage
    , getItemById
    , getItemName
    , getItemEffects
    )

import Dict exposing (Dict)
import Params exposing (Param(..), paramToString)

type alias PageItem =
    { pageId : String
    , itemId : String
    }

type alias ItemEffects = Dict String Int

type alias Item =
    { name : String
    , buffs : ItemEffects
    , penalties : ItemEffects
    }

seedItem : String -> Item
seedItem name =
    { name = name, buffs = Dict.empty, penalties = Dict.empty }

withBuff : Param -> Int -> Item -> Item
withBuff param value i =
    { i | buffs = Dict.insert (paramToString param) value i.buffs }

withPenalty : Param -> Int -> Item -> Item
withPenalty param value i =
    { i | penalties = Dict.insert (paramToString param) value i.penalties }

firstItem : Item
firstItem =
    seedItem "firstItem"
        |> withBuff Endurance 3

secondItem : Item
secondItem =
    seedItem "secondItem"
        |> withBuff Curiosity 1
        |> withPenalty Intellect 1

thirdItem : Item
thirdItem =
    seedItem "thirdItem"
        |> withBuff Intellect 1

availableItems : List Item
availableItems = [ firstItem, secondItem, thirdItem ]

pickupPages : List PageItem
pickupPages =
    [ { pageId = "mint", itemId = "firstItem" }
    , { pageId = "ux", itemId = "secondItem" }
    , { pageId = "roguelike", itemId = "thirdItem" }
    ]

pageDict : Dict String String
pageDict =
    Dict.fromList (List.map (\p -> ( p.pageId, p.itemId )) pickupPages)

getItemFromPage : String -> Maybe String
getItemFromPage pageId =
    Dict.get pageId pageDict

itemsDict : Dict String Item
itemsDict =
    Dict.fromList (List.map (\i -> ( i.name, i )) availableItems)

getItemById : String -> Maybe Item
getItemById itemId =
    Dict.get itemId itemsDict

getItemName : String -> String
getItemName itemId =
    getItemById itemId
        |> Maybe.map .name
        |> Maybe.withDefault "???"

getItemEffects : Item -> ItemEffects
getItemEffects item =
    let
        penalties = Dict.map (\_ value -> -value) item.penalties
    in
    Dict.union item.buffs penalties
