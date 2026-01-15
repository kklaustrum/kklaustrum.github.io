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

-- ------------------------------------------------------------------
-- «обёртка» для контейнера
-- ------------------------------------------------------------------
novelContainer : List (Html msg) -> Html msg
novelContainer children =
    div [ class "novel-container" ] children

-- ------------------------------------------------------------------
-- UI‑компоненты
-- ------------------------------------------------------------------
choiceButton : String -> String -> Html Msg
choiceButton label pageId =
    button
        [ onClick (GoToPage pageId)
        , class "choice-btn"
        ]
        [ text label ]

{-| Список вариантов‑выбора.
    `choices` – список кортежей `(label, pageId)`.
-}
viewChoices : List ( String, String ) -> Html Msg
viewChoices choices =
    div [ class "choices" ]
        (List.map
            (\( label, pageId ) -> choiceButton label pageId)
            choices
        )

{-| Превращение списка строк‑абзацев в список `p`‑элементов.
    Возвращение **List (Html msg)**, а не один `Html`.
-}
viewParagraphs : List String -> List (Html msg)
viewParagraphs paragraphs =
    List.map (\para -> p [ class "paragraph" ] [ text para ]) paragraphs

-- ------------------------------------------------------------------
-- «страницы»
-- ------------------------------------------------------------------
viewPage : Dict String PageData -> String -> Html Msg
viewPage pages currentPage =
    case Dict.get currentPage pages of
        Just pageData ->
            novelContainer
                [ h1 [] [ text pageData.title ]
                , div [ class "page-content" ] (viewParagraphs pageData.content)
                , viewChoices pageData.choices
                ]

        Nothing ->
            novelContainer
                [ h1 [] [ text "Страница не найдена" ]
                , p [] [ text ("ID: " ++ currentPage) ]
                , viewChoices [ ( "На главную", "start" ) ]
                ]

viewLoading : Html msg
viewLoading =
    novelContainer [ h1 [] [ text "Загрузка книги…" ] ]

viewError : String -> Html msg
viewError errMsg =
    novelContainer
        [ h1 [] [ text "Ошибка" ]
        , p [] [ text errMsg ]
        ]
