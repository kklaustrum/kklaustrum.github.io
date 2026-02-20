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
import Rules exposing (standardRules, evaluate, PageMode(..))

--------------------------------------------------------------------
-- ViewMode
--------------------------------------------------------------------
type ViewMode
    = ShowItemPickup String
    | ShowPageNotFound String
    | ShowGameOver
    | ShowNormalPage Page
    | ShowSecretPage

determineViewMode : Config -> Locale -> Dict String Page -> WorldState -> Character -> String -> ViewMode
determineViewMode config locale storyline world character currentPage =
    case Rules.evaluate Rules.standardRules world character currentPage storyline of
        Rules.NormalPage _ -> 
            Dict.get currentPage storyline
                |> Maybe.map ShowNormalPage
                |> Maybe.withDefault (ShowPageNotFound currentPage)
        Rules.SecretPage _ -> 
            ShowSecretPage
        Rules.GameOverPage -> 
            ShowGameOver
        Rules.ItemPickup itemId -> 
            ShowItemPickup itemId
        Rules.PageNotFound pid -> 
            ShowPageNotFound pid

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
