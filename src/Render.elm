module Render exposing
    ( renderItemPickup, renderPageNotFound, renderGameOver, renderPassagePage,renderNormalPage
    , pageLayout
    , pageContainer
    )

import Html exposing (Html)
import Messages exposing (Msg(..))
import Locale exposing (Locale)
import World exposing (WorldState)
import Character exposing (Character)
import UiClasses exposing (..)
import Components exposing (..)
import Utils exposing (Config, debugData, formatItemPickup, listWhen)
import Types exposing (PageContent, ExtraChoices, RenderContext, EquippedItems(..), StashItems(..))
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

toEquippedItem : (Locale -> String -> String) -> Locale -> String -> (String, String, Msg)
toEquippedItem itemHint locale id =
    (id, Display.itemEffectHint locale id, Messages.moveToStash id)

toStashItem : (Locale -> String -> String) -> Locale -> String -> (String, String, Msg)
toStashItem itemHint locale id =
    (id, Display.itemEffectHint locale id, Messages.moveToEquipped id)

pageLayout : RenderContext -> PageLayout -> HtmlList
pageLayout ctx content =
    let
        debugInfo = debugData ctx.world ctx.currentPage
        { locale, character, config } = ctx
        { stash, equipped, params } = character
        { showDebugInfo } = config

        equippedItems =
            equipped
                |> List.map (toEquippedItem Display.itemEffectHint locale)
                |> EquippedItems

        stashItems =
            stash
                |> List.map (toStashItem Display.itemEffectHint locale)
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

renderItemPickup : RenderContext -> String -> HtmlList
renderItemPickup ctx itemId =
    [ titleHtml ctx.locale.inventoryLabel
    , paragraphNode (formatItemPickup ctx.locale (Display.itemName itemId))
    , itemChoiceButtons itemId
    ]

renderPageNotFound : RenderContext -> HtmlList
renderPageNotFound ctx =
    [ errorTitleNode ctx.locale.pageNotFound
    , paragraphNode ("ID: " ++ ctx.currentPage)
    , singleChoice ctx.locale.backToHomeLabel "start"
    ]

renderGameOver : RenderContext -> HtmlList
renderGameOver ctx =
    [ gameOverNode ctx.locale.gameOver
    , actionButton ctx.locale.backToHomeLabel ReturnToStart
    ]

renderPassagePage : RenderContext -> PageContent -> HtmlList
renderPassagePage ctx pc =
    pageLayout ctx
        { title   = titleHtml pc.title
        , content = contentHtml [ pc.content ]
        , choices = pc.choices
        }

renderNormalPage : RenderContext -> Page -> ExtraChoices -> HtmlList
renderNormalPage ctx page extraChoices =
    pageLayout ctx
        { title   = titleHtml page.title
        , content = contentHtml page.content
        , choices = page.choices ++ extraChoices
        }
