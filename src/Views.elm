module Views exposing
    ( viewLoading
    , viewError
    , viewPage
    , viewChoices
    , viewParagraphs
    , choiceButton
    )

import Dict exposing (Dict)
import Html exposing (Html, button, div, h1, p, text)
import Html.Attributes exposing (class)
import Html.Events exposing (onClick)

import Pages exposing (PageData)
import Messages exposing (Msg(..))
import Locale exposing (Locale)

import UiClasses exposing
    ( bodyCls
    , novelContainerCls
    , pageTitleCls
    , paragraphCls
    , pageContentCls
    , loadingTitleCls
    , errorTitleCls
    , choicesContainerCls
    , choiceBtnCls
    , backToHomeBtnCls
    , pulseAnimationCls
    )

-- ------------------------------------------------------------------
-- Обёртка‑контейнер
-- ------------------------------------------------------------------
novelContainer : List (Html msg) -> Html msg
novelContainer children =
    div [ class novelContainerCls ] children

-- ------------------------------------------------------------------
-- UI‑компоненты
-- ------------------------------------------------------------------
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

-- ------------------------------------------------------------------
-- Страницы
-- ------------------------------------------------------------------
viewPage : Locale -> Dict String PageData -> String -> Html Msg
viewPage locale pages currentPage =
    case Dict.get currentPage pages of
        Just pageData ->
            novelContainer
                [ h1 [ class pageTitleCls ] [ text pageData.title ]
                , div [ class pageContentCls ] (viewParagraphs pageData.content)
                , viewChoices pageData.choices
                ]

        Nothing ->
            novelContainer
                [ h1 [ class errorTitleCls ] [ text locale.pageNotFound ]
                , p [] [ text ("ID: " ++ currentPage) ]
                , viewChoices [ ( locale.backToHomeLabel, "start" ) ]
                ]

viewLoading : Locale -> Html msg
viewLoading locale =
    novelContainer
        [ h1 [ class (loadingTitleCls ++ " " ++ pulseAnimationCls) ]
            [ text locale.loading ]
        ]

viewError : Locale -> String -> Html msg
viewError locale errMsg =
    novelContainer
        [ h1 [ class errorTitleCls ] [ text locale.errorTitle ]
        , p [] [ text errMsg ]
        ]
