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
import Components exposing (choiceButton, viewChoices)
import Utils exposing (Config, extraInfo, gameOverInfo)

-- ------------------------------------------------------------------
-- Render
-- ------------------------------------------------------------------
renderItemPickup : Config -> Locale -> String -> Maybe String -> List (Html Msg)
renderItemPickup config locale itemId maybePrevPage =
    let
        maybeItem = Items.getItemById itemId
        itemName =
            case maybeItem of
                Just foundItem -> foundItem.name
                Nothing        -> "???"

        pickupText = String.replace "%s" itemName locale.itemPickedUp
        backPage = Maybe.withDefault "start" maybePrevPage
    in
    [ h1 [ class pageTitleCls ] [ text locale.inventoryLabel ]
    , p [ class paragraphCls ] [ text pickupText ]
    , choiceButton "Ok" backPage
    ]

renderPageNotFound : Config -> Locale -> String -> List (Html Msg)
renderPageNotFound config locale currentPage =
    [ h1 [ class errorTitleCls ] [ text locale.pageNotFound ]
    , p [] [ text ("ID: " ++ currentPage) ]
    , choiceButton locale.backToHomeLabel "start"
    ]

renderGameOver : Config -> Locale -> WorldState -> Character -> String -> List (Html Msg)
renderGameOver config locale world character currentPage =
    gameOverInfo locale world character currentPage

-- -----------------------------------------------------------------
-- Helpers and renderNormalPage
-- -----------------------------------------------------------------

titleHtml : Page -> List (Html Msg)
titleHtml page =
    [ h1 [ class pageTitleCls ] [ text page.title ] ]

contentHtml : Page -> List (Html Msg)
contentHtml page =
    List.map
        (\para ->
            div [ class pageContentCls ]
                [ p [ class paragraphCls ] [ text para ] ]
        )
        page.content

debugHtml : Config -> Locale -> WorldState -> Character -> String -> List (Html Msg)
debugHtml config locale world character curPage =
    extraInfo config locale world character curPage

choicesHtml : Page -> List (Html Msg)
choicesHtml page =
    [ viewChoices page.choices ]

renderNormalPage : Config -> Locale -> Dict String Page -> WorldState -> Character -> String -> List (Html Msg)
renderNormalPage config locale storyline world character currentPage =
    case Dict.get currentPage storyline of
        Nothing ->
            []

        Just page ->
            titleHtml page
                ++ contentHtml page
                ++ debugHtml config locale world character currentPage
                ++ choicesHtml page
