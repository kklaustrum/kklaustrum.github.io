module Components exposing
    ( novelContainer
    , choiceButton
    , viewChoices
    , viewParagraphs
    , titleHtml
    , contentHtml
    , debugInfo
    , gameOverInfo
    , paramsInfo
    , inventoryInfo
    , viewLoading
    , viewError
    )

import Dict exposing (Dict)
import Html exposing (Html, button, div, h1, hr, p, text)
import Html.Attributes exposing (class)
import Html.Events exposing (onClick)

import Locale exposing (Locale)
import UiClasses exposing (..)
import Messages exposing (Msg(..), goToPage)
import Utils exposing (Config, formatDebugInfoPure, formatParamsData, formatInventoryData)

-- -----------------------------------------------------------------
-- UI components
-- -----------------------------------------------------------------
novelContainer : List (Html msg) -> Html msg
novelContainer children =
    div [ class novelContainerCls ] children

choiceButton : (String, String) -> Html Msg
choiceButton (label, pageId) =
    button [ onClick (GoToPage pageId), class choiceBtnCls ] [ text label ]

viewChoices : List (String, String) -> Html Msg
viewChoices choices =
    div [ class choicesContainerCls ] (List.map choiceButton choices)

viewParagraphs : List String -> List (Html msg)
viewParagraphs paras =
    List.map (\para -> p [ class paragraphCls ] [ text para ]) paras

viewLoading : Locale -> Html Msg
viewLoading locale =
    novelContainer
        [ h1 [ class (loadingTitleCls ++ " " ++ pulseAnimationCls) ] [ text locale.loading ] ]

viewError : Locale -> String -> Html msg
viewError locale errMsg =
    novelContainer
        [ h1 [ class errorTitleCls ] [ text locale.errorTitle ]
        , p [] [ text errMsg ]
        ]

titleHtml : String -> Html Msg
titleHtml title =
    h1 [ class pageTitleCls ] [ text title ]

contentHtml : List String -> List (Html Msg)
contentHtml paragraphs =
    List.map (\para -> div [ class pageContentCls ] [ p [ class paragraphCls ] [ text para ] ]) paragraphs

debugInfo config locale { currentPage, visits, path } =
    case config.showDebugInfo of
        True ->
            [ hr [ class debugDividerCls ] []
            , p [ class debugInfoCls ] 
                [ text (Utils.formatDebugInfoPure locale currentPage visits path) ]
            ]
        False -> []

paramsInfo : Locale -> Dict String Int -> List (Html Msg)
paramsInfo locale params =
    [ p [ class debugInfoCls ] [ text (Utils.formatParamsData locale params) ] ]

inventoryInfo : Locale -> List String -> List (Html Msg)
inventoryInfo locale items =
    [ p [ class debugInfoCls ] [ text (Utils.formatInventoryData locale items) ] ]

gameOverInfo : Locale -> Bool -> List (Html Msg)
gameOverInfo locale isGameOver =
    if isGameOver then
        [ p [ class gameOverCls ] [ text locale.gameOver ] ]
    else []
