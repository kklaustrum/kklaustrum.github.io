module Views exposing (viewPage)

import Dict exposing (Dict)
import Html exposing (Html)
import Html.Attributes exposing (class)
import Html.Events exposing (onClick)

import Veil exposing (Page)
import Messages exposing (Msg(..))
import Locale exposing (Locale)
import UiClasses exposing (..)
import Utils exposing (Config)
import World exposing (WorldState)
import Items exposing (getItemFromPage)
import Character exposing (Character)

import Render exposing (renderItemPickup, renderPageNotFound, renderGameOver, renderNormalPage)
import Components exposing (novelContainer, viewLoading, viewError)

--------------------------------------------------------------------
-- ViewMode
--------------------------------------------------------------------
type ViewMode
    = ShowItemPickup String (Maybe String)
    | ShowPageNotFound String
    | ShowGameOver
    | ShowNormalPage Page

determineViewMode :
    Config
    -> Locale
    -> Dict String Page
    -> WorldState
    -> Character
    -> String          -- currentPage
    -> Maybe String    -- previousPage (Maybe Nothing)
    -> ViewMode
determineViewMode config locale storyline world character currentPage mPrevPage =
    case Items.getItemFromPage currentPage of
        Just itemId ->
            if List.member itemId character.prevInventory then
                case Dict.get currentPage storyline of
                    Nothing ->
                        ShowPageNotFound currentPage

                    Just page ->
                        if World.hasReachedThreshold currentPage world then
                            ShowGameOver
                        else
                            ShowNormalPage page
            else
                ShowItemPickup itemId mPrevPage

        Nothing ->
            case Dict.get currentPage storyline of
                Nothing ->
                    ShowPageNotFound currentPage

                Just page ->
                    if World.hasReachedThreshold currentPage world then
                        ShowGameOver
                    else
                        ShowNormalPage page

-- ------------------------------------------------------------------
-- viewPage
-- ------------------------------------------------------------------
viewPage : Config -> Locale -> Dict String Page -> WorldState -> Character -> Maybe String -> String -> Html Msg
viewPage config locale storyline world character mPrevPage currentPage =
    let
        mode =
            determineViewMode config locale storyline world character currentPage mPrevPage

        pageElements =
            case mode of
                ShowItemPickup itemId mPrev ->
                    renderItemPickup config locale itemId mPrev

                ShowPageNotFound pid ->
                    renderPageNotFound config locale pid

                ShowGameOver ->
                    renderGameOver config locale world character currentPage

                ShowNormalPage _ ->
                    renderNormalPage config locale storyline world character currentPage
    in
    novelContainer pageElements
