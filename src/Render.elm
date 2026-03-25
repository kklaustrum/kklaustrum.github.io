module Render exposing
    ( renderItemPickup
    , renderPageNotFound
    , renderGameOver
    , renderNormalPage
    , renderSecretPage
    , pageLayout
    , pageContainer
    )

import Html exposing (Html)
import Veil exposing (Page)
import Messages exposing (Msg(..))
import Locale exposing (Locale)
import World exposing (WorldState)
import Character exposing (Character)
import UiClasses exposing (..)
import Components exposing (..)
import Utils exposing (Config, debugData, formatItemPickup)
import Types exposing (SecretContent, ExtraChoices, RenderContext)
import Items

type alias HtmlList = List (Html Msg)

type alias PageContent =
    { title : Html Msg
    , content : HtmlList
    , choices : List (String, String)
    }

pageContainer : HtmlList -> Html Msg
pageContainer content =
    Components.novelContainer content

pageLayout : RenderContext -> PageContent -> HtmlList
pageLayout ctx content =
    let
        debugInfo = debugData ctx.world ctx.currentPage
        debugSections =
            List.concat
                [ paramsSection ctx.locale (Character.allParamsData ctx.character)
                , inventorySection ctx.locale ctx.character.stash ctx.character.equipped
                , debugSection ctx.config.showDebugInfo ctx.locale debugInfo.currentPage debugInfo.visits debugInfo.path
                ]
    in
    List.concat
        [ [ content.title ]
        , content.content
        , debugSections
        , nonEmptyChoices content.choices
        ]

nonEmptyChoices : ExtraChoices -> HtmlList
nonEmptyChoices choices =
    if List.isEmpty choices then [] else [ viewChoices choices ]

renderItemPickup : RenderContext -> String -> HtmlList
renderItemPickup ctx itemId =
    [ titleHtml ctx.locale.inventoryLabel
    , paragraphNode (formatItemPickup ctx.locale (Items.getItemName itemId))
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
    [ gameOverNode ctx.locale.gameOver ]

renderSecretPage : RenderContext -> SecretContent -> HtmlList
renderSecretPage ctx secretContent =
    [ titleHtml secretContent.title
    , paragraphNode secretContent.content
    , viewChoices secretContent.choices
    ]

renderNormalPage : RenderContext -> Page -> ExtraChoices -> HtmlList
renderNormalPage ctx page extraChoices =
    pageLayout ctx
        { title = titleHtml page.title
        , content = contentHtml page.content
        , choices = page.choices ++ extraChoices
        }
