module Engine exposing (applyPageVisit)

import World exposing (WorldState)
import Character exposing (Character)
import Items
import Utils exposing (maybeWhen)

type alias VisitResult =
    { world : WorldState
    , character : Character
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

pickUpItem : Character -> String -> Character
pickUpItem character itemId =
    character
        |> Character.addItem itemId
        |> applyItemEffects itemId

applyNewItem : String -> Character -> Character
applyNewItem pageId character =
    Items.getItemFromPage pageId
        |> Maybe.andThen (unpickedItem character)
        |> Maybe.map (pickUpItem character)
        |> Maybe.withDefault character

applyPageVisit : String -> String -> WorldState -> Character -> VisitResult
applyPageVisit pageId currentPage world character =
    { world = World.addVisitIfNew pageId world currentPage
    , character =
        character
            |> Character.updatePrevInventory
            |> applyNewItem pageId
    }
