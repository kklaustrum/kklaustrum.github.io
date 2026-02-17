module Components exposing
    ( novelContainer
    , choiceButton
    , viewChoices
    , viewParagraphs
    , viewLoading
    , viewError
    )

import Html exposing (Html, button, div, h1, p, text)
import Html.Attributes exposing (class)
import Html.Events exposing (onClick)

import Locale exposing (Locale)
import UiClasses exposing (..)
import Messages exposing (Msg(..), goToPage)

-- -----------------------------------------------------------------
-- UI components
-- -----------------------------------------------------------------
novelContainer : List (Html msg) -> Html msg
novelContainer children =
    div [ class novelContainerCls ] children

choiceButton : String -> String -> Html Msg
choiceButton label pageId =
    button
        [ onClick (GoToPage pageId)
        , class choiceBtnCls
        ]
        [ text label ]

viewChoices : List ( String, String ) -> Html Msg
viewChoices choicePairs =
    div [ class choicesContainerCls ]
        (List.map (\( lbl, pid ) -> choiceButton lbl pid) choicePairs)


viewParagraphs : List String -> List (Html msg)
viewParagraphs paras =
    List.map (\para -> p [ class paragraphCls ] [ text para ]) paras


viewLoading : Locale -> Html msg
viewLoading locale =
    novelContainer
        [ h1 [ class (loadingTitleCls ++ " " ++ pulseAnimationCls) ] [ text locale.loading ] ]

viewError : Locale -> String -> Html msg
viewError locale errMsg =
    novelContainer
        [ h1 [ class errorTitleCls ] [ text locale.errorTitle ]
        , p [] [ text errMsg ]
        ]
