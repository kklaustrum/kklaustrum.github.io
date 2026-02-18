module Render exposing
    ( renderItemPickup
    , renderPageNotFound
    , renderGameOver
    , renderNormalPage
    )

import Dict exposing (Dict)
import Html exposing (Html, h1, p, div, text)
import Html.Attributes exposing (class)

import Veil exposing (Page)
import Messages exposing (Msg(..), goToPage)
import Locale exposing (Locale)
import World exposing (WorldState)
import Character exposing (Character)

import UiClasses exposing (..)
import Items exposing (getItemById)
import Components exposing (choiceButton, viewChoices, titleHtml, contentHtml, gameOverInfo, debugInfo)
import Utils exposing (Config)

-- ------------------------------------------------------------------
-- Render
-- ------------------------------------------------------------------
renderItemPickup : Config -> Locale -> String -> String -> List (Html Msg)
renderItemPickup config locale itemId currentPage =
    let
        maybeItem = Items.getItemById itemId
        itemName =
            case maybeItem of
                Just foundItem -> foundItem.name
                Nothing        -> "???"

        pickupText = String.replace "%s" itemName locale.itemPickedUp
    in
    [ h1 [ class pageTitleCls ] [ text locale.inventoryLabel ]
    , p [ class paragraphCls ] [ text pickupText ]
    , div [ class centeredChoiceCls ]
        [ choiceButton ("Ok", currentPage) ]
    ]

renderPageNotFound : Config -> Locale -> String -> List (Html Msg)
renderPageNotFound config locale currentPage =
    [ h1 [ class errorTitleCls ] [ text locale.pageNotFound ]
    , p [] [ text ("ID: " ++ currentPage) ]
    , choiceButton (locale.backToHomeLabel, "start")
    ]

renderGameOver : Config -> Locale -> WorldState -> Character -> String -> List (Html Msg)
renderGameOver config locale world character currentPage =
    Components.gameOverInfo locale (Utils.isGameOver world currentPage)

-- -----------------------------------------------------------------
-- Helpers and renderNormalPage
-- -----------------------------------------------------------------

debugHtml : Config -> Locale -> WorldState -> Character -> String -> List (Html Msg)
debugHtml config locale world character currentPage =
    Components.debugInfo config locale (Utils.debugData world currentPage)

choicesHtml : Page -> List (Html Msg)
choicesHtml page =
    [ viewChoices page.choices ]

renderNormalPage config locale storyline world character currentPage =
    case Dict.get currentPage storyline of
        Nothing -> []
        Just page ->
            let
                debug = Utils.debugData world currentPage
                params = Utils.paramData character
                gameOver = Utils.isGameOver world currentPage
            in
            [ Components.titleHtml page.title ]
                ++ Components.contentHtml page.content
                ++ Components.debugInfo config locale debug
                ++ Components.paramsInfo locale params
                ++ Components.inventoryInfo locale character.inventory
                ++ Components.gameOverInfo locale gameOver
                ++ [ Components.viewChoices page.choices ]
