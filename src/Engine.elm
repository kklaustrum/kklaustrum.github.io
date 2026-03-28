module Engine exposing (VisitResult, applyPageVisit, applyStashChoice, applyEquipChoice, applyMoveToStash, applyMoveToEquipped, itemEffectHint)

import Dict exposing (Dict)
import World exposing (WorldState)
import Character exposing (Character)
import Items
import Utils exposing (maybeWhen, formatParamShort)
import Locale exposing (Locale)

type alias VisitResult =
    { world : WorldState
    , character : Character
    , pendingItem : Maybe String
    }

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
    let
        updatedCharacter = Character.updatePrevInventory character
    in
    { world       = World.addVisitIfNew pageId world currentPage
    , character   = updatedCharacter
    , pendingItem = pendingItemOnPage pageId updatedCharacter
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

itemEffectHint : Locale -> String -> String
itemEffectHint locale itemId =
    Items.getItemById itemId
        |> Maybe.map Items.getItemEffects
        |> Maybe.map (formatEffects locale)
        |> Maybe.withDefault ""

formatEffects : Locale -> Dict String Int -> String
formatEffects locale effects =
    Dict.toList effects
        |> List.map (Utils.formatParamShort locale)
        |> String.join " "
