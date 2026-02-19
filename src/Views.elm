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

import Render exposing (renderItemPickup, renderPageNotFound, renderGameOver, renderNormalPage, renderSecretPage)
import Components exposing (novelContainer, viewLoading, viewError)

--------------------------------------------------------------------
-- ViewMode
--------------------------------------------------------------------
type ViewMode
    = ShowItemPickup String
    | ShowPageNotFound String
    | ShowGameOver
    | ShowNormalPage Page
    | ShowSecretPage

determineViewMode :
    Config
    -> Locale
    -> Dict String Page
    -> WorldState
    -> Character
    -> String          -- currentPage
    -> ViewMode

determineViewMode config locale storyline world character currentPage =
    if isSecretPage currentPage character then
        ShowSecretPage
    else if isPickupPage currentPage character then
        ShowItemPickup (Items.getItemFromPage currentPage |> Maybe.withDefault "")
    else
        defaultPageMode storyline world currentPage

isSecretPage : String -> Character -> Bool
isSecretPage page character = page == "secret" && Character.hasAtLeastTwoItems character.inventory

isPickupPage : String -> Character -> Bool
isPickupPage page character =
    case Items.getItemFromPage page of
        Just itemId ->
            not (List.member itemId character.prevInventory)
        Nothing ->
            False

defaultPageMode : Dict String Page -> WorldState -> String -> ViewMode
defaultPageMode storyline world page =
    case Dict.get page storyline of
        Nothing -> ShowPageNotFound page
        Just p -> if World.hasReachedThreshold page world then ShowGameOver else ShowNormalPage p

-- ------------------------------------------------------------------
-- viewPage
-- ------------------------------------------------------------------
viewPage : Config -> Locale -> Dict String Page -> WorldState -> Character -> String -> Html Msg
viewPage config locale storyline world character currentPage =
    let
        mode =
            determineViewMode config locale storyline world character currentPage

        pageElements =
            case mode of
                ShowItemPickup itemId ->
                    renderItemPickup config locale itemId currentPage

                ShowPageNotFound pid ->
                    renderPageNotFound config locale pid

                ShowGameOver ->
                    renderGameOver config locale world character currentPage

                ShowNormalPage _ ->
                    renderNormalPage config locale storyline world character currentPage

                ShowSecretPage ->
                    renderSecretPage config locale world character
    in
    novelContainer pageElements
