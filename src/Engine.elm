module Engine exposing (VisitResult, applyPageVisit, applyStashChoice, applyEquipChoice, applyMoveToStash, applyMoveToEquipped, applyItemMsg)

import World exposing (addVisitIfNew)
import Character exposing (moveToEquipped, moveToStash, addToStash, removeEffects, equipItem, updatePrevInventory)
import Items
import Utils exposing (maybeWhen)
import Messages exposing (ItemMsg(..))
import Types exposing (Character, WorldState)
import Passages exposing (traitsForPage)

type alias VisitResult =
    { world : WorldState
    , character : Character
    }

applyItemMsg : ItemMsg -> Character -> Character
applyItemMsg msg character =
    case msg of
        Stash id          -> applyStashChoice id character
        Equip id          -> applyEquipChoice id character
        MoveToStash id    -> applyMoveToStash id character
        MoveToEquipped id -> applyMoveToEquipped id character

applyItemEffects : String -> Character -> Character
applyItemEffects itemId character =
    Items.getItemById itemId
        |> Maybe.map Items.getItemEffects
        |> Maybe.map (\effects -> Character.applyEffects effects character)
        |> Maybe.withDefault character

unpickedItem : Character -> String -> Maybe String
unpickedItem character itemId =
    Utils.maybeWhen (not (Character.hasPickedUp itemId character)) itemId

pendingItemOnPage : String -> Character -> Maybe String
pendingItemOnPage pageId character =
    Items.getItemFromPage pageId
        |> Maybe.andThen (unpickedItem character)

applyPageVisit : String -> String -> WorldState -> Character -> VisitResult
applyPageVisit pageId currentPage world character =
    { world     = World.addVisitIfNew pageId world currentPage
    , character = character
        |> Character.updatePrevInventory
        |> (\c -> List.foldl Character.addTrait c (Passages.traitsForPage pageId))
    }

applyStashChoice : String -> Character -> Character
applyStashChoice itemId character =
    character
        |> Character.addToStash itemId
        |> Character.updatePrevInventory

applyEquipChoice : String -> Character -> Character
applyEquipChoice itemId character =
    character
        |> Character.equipItem itemId
        |> applyItemEffects itemId
        |> Character.updatePrevInventory

removeItemEffects : String -> Character -> Character
removeItemEffects itemId character =
    Items.getItemById itemId
        |> Maybe.map Items.getItemEffects
        |> Maybe.map (\effects -> Character.removeEffects effects character)
        |> Maybe.withDefault character

applyMoveToStash : String -> Character -> Character
applyMoveToStash itemId character =
    character
        |> removeItemEffects itemId
        |> Character.moveToStash itemId

applyMoveToEquipped : String -> Character -> Character
applyMoveToEquipped itemId character =
    character
        |> Character.moveToEquipped itemId
        |> applyItemEffects itemId
