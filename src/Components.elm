module Components exposing
    ( novelContainer
    , statsGrid
    , choiceButton
    , viewChoices
    , titleHtml
    , contentHtml
    , viewParagraphs
    , viewLoading
    , viewError
    , debugSection
    , paramsSection
    , inventorySection
    , gameOverSection
    , paragraphNode
    , errorTitleNode  
    , gameOverNode
    , singleChoice
    , textNode
    , itemChoiceButtons
    )

import Dict exposing (Dict)
import Html exposing (Html, span, button, div, h1, hr, p, text)
import Html.Attributes exposing (class)
import Html.Events exposing (onClick)

import Locale exposing (Locale)
import UiClasses exposing (..)
import Utils exposing (formatParamsData, formatParamLabel, formatParamValue, formatInventoryData, formatEquippedData, formatStashData, formatDebugInfoPure)
import Messages exposing (Msg(..), stashItem, equipItem)

-- -----------------------------------------------------------------
-- UI components
-- -----------------------------------------------------------------
novelContainer : List (Html msg) -> Html msg
novelContainer children =
    div [ class novelContainerCls ] children

statsGrid : List (Html msg) -> List (Html msg) -> Html msg
statsGrid left right =
    div [ class statsGridCls ]
        [ div [] left
        , div [] right
        ]

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
    List.map paragraphNode paragraphs

debugSection : Bool -> Locale -> String -> Int -> List String -> List (Html msg)
debugSection showDebug locale currentPage visits path =
    if showDebug then
        [ hr [ class debugDividerCls ] []
        , p [ class debugInfoCls ] [ text (formatDebugInfoPure locale currentPage visits path) ]
        ]
    else []

paramsSection : Locale -> Dict String Int -> List (Html msg)
paramsSection locale params =
    [ p [ class debugInfoCls ] [ text (formatParamsData locale) ] ]
    ++ List.map (\entry ->
        div [ class inventoryRowCls ]
            [ span [ class rowTagCls ] [ text (formatParamLabel locale entry) ]
            , span [] [ text (formatParamValue locale entry) ]
            ]
        ) (Dict.toList params)

inventorySection : Locale -> List String -> List String -> List (Html msg)
inventorySection locale stash equipped =
    [ p [ class debugInfoCls ] [ text locale.inventoryLabel ]
    , div [ class inventoryRowCls ]
        [ span [ class rowTagCls ] [ text "equip" ]
        , span [] [ text (formatEquippedData locale equipped) ]
        ]
    , div [ class inventoryRowCls ]
        [ span [ class rowTagCls ] [ text "stash" ]
        , span [] [ text (formatStashData locale stash) ]
        ]
    ]

gameOverSection : Locale -> Bool -> List (Html msg)
gameOverSection locale isGameOver =
    if isGameOver then [ p [ class gameOverCls ] [ text locale.gameOver ] ] else []

singleChoice : String -> String -> Html Msg
singleChoice label pageId = div [ class centeredChoiceCls ] [ choiceButton (label, pageId) ]

textNode : String -> Html msg
textNode content = text content

paragraphNode : String -> Html msg
paragraphNode content = p [ class paragraphCls ] [ textNode content ]

errorTitleNode : String -> Html msg
errorTitleNode content = h1 [ class errorTitleCls ] [ textNode content ]

gameOverNode : String -> Html msg
gameOverNode content = p [ class gameOverCls ] [ textNode content ]

itemChoiceButtons : String -> Html Msg
itemChoiceButtons itemId =
    div [ class centeredChoiceCls ]
        [ button [ onClick (Messages.equipItem itemId), class choiceBtnCls ] [ text "equip" ]
        , button [ onClick (Messages.stashItem itemId), class choiceBtnCls ] [ text "stash" ]
        ]
