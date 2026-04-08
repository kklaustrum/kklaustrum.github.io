module Render exposing
    ( renderItemPickup, renderPageNotFound, renderGameOver, renderPassagePage,renderNormalPage
    , pageLayout
    , pageContainer
    )

import Html exposing (Html)
import Messages exposing (Msg(..))
import Locale exposing (Locale)
import World exposing (WorldState)
import UiClasses exposing (..)
import Components exposing (..)
import Utils exposing (Config, debugData, formatItemPickup, listWhen)
import Types exposing (PageContent, ExtraChoices, UIContext, GameContext, InventoryContext, EquippedItems(..), StashItems(..))
import Display exposing (itemEffectHint, itemName)
import Veil exposing (Page)

type alias HtmlList = List (Html Msg)

type alias PageLayout =
    { title : Html Msg
    , content : HtmlList
    , choices : List (String, String)
    }

pageContainer : HtmlList -> Html Msg
pageContainer content =
    Components.novelContainer content

toEquippedItem : Locale -> String -> (String, String, Msg)
toEquippedItem locale id =
    (id, Display.itemEffectHint locale id, Messages.moveToStash id)

toStashItem : Locale -> String -> (String, String, Msg)
toStashItem locale id =
    (id, Display.itemEffectHint locale id, Messages.moveToEquipped id)

pageLayout : UIContext -> GameContext -> InventoryContext -> PageLayout -> HtmlList
pageLayout ui game inventory content =
    let
        debugInfo = debugData game.world game.currentPage
        { locale, config } = ui
        { stash, equipped, params } = inventory
        { showDebugInfo } = config

        equippedItems =
            equipped
                |> List.map (toEquippedItem locale)
                |> EquippedItems

        stashItems =
            stash
                |> List.map (toStashItem locale)
                |> StashItems
    in
    List.concat
        [ [ content.title ]
        , content.content
        , [ statsLayout
            (paramsSection locale params)
            (inventorySection locale equippedItems stashItems)
            (currentPageSection showDebugInfo locale debugInfo.currentPage debugInfo.visits)
            (pathSection showDebugInfo locale debugInfo.path)
        ]
        , nonEmptyChoices content.choices
        ]

nonEmptyChoices : ExtraChoices -> HtmlList
nonEmptyChoices choices =
    listWhen (not (List.isEmpty choices)) (viewChoices choices)

renderItemPickup : UIContext -> String -> HtmlList
renderItemPickup ui itemId =
    [ titleHtml ui.locale.inventoryLabel
    , paragraphNode (formatItemPickup ui.locale (Display.itemName itemId))
    , itemChoiceButtons itemId
    ]

renderPageNotFound : UIContext -> GameContext -> HtmlList
renderPageNotFound ui game =
    [ errorTitleNode ui.locale.pageNotFound
    , paragraphNode ("ID: " ++ game.currentPage)
    , singleChoice ui.locale.backToHomeLabel "start"
    ]

renderGameOver : UIContext -> HtmlList
renderGameOver ui =
    [ gameOverNode ui.locale.gameOver
    , actionButton ui.locale.backToHomeLabel ReturnToStart
    ]

renderPassagePage : UIContext -> GameContext -> InventoryContext -> PageContent -> HtmlList
renderPassagePage ui game inventory pc =
    pageLayout ui game inventory
        { title   = titleHtml pc.title
        , content = contentHtml [ pc.content ]
        , choices = pc.choices
        }

renderNormalPage : UIContext -> GameContext -> InventoryContext -> Page -> ExtraChoices -> HtmlList
renderNormalPage ui game inventory page extraChoices =
    pageLayout ui game inventory
        { title   = titleHtml page.title
        , content = contentHtml page.content
        , choices = page.choices ++ extraChoices
        }
