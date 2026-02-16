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
import String exposing (fromInt)

import Veil exposing (Page)
import Messages exposing (Msg(..), goToPage)
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

import Utils exposing (Config, extraInfo, gameOverInfo)
import World exposing (WorldState, hasReachedThreshold, visitCount)
import Items exposing (getItemFromPage, getItemById)
import Character exposing (Character)

type alias ModalContent msg =
    { title : String
    , content : List (Html msg)
    , buttons : List (Html msg)
    }

type alias ModalConfig =
    { containerClass : String
    , titleClass : String
    }

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
viewModal : ModalConfig -> Locale -> ModalContent msg -> Html msg
viewModal config locale modal =
    novelContainer
        [ h1 [ class config.titleClass ] [ text modal.title ]
        , div [ class pageContentCls ] modal.content
        , div [ class choicesContainerCls ] modal.buttons
        ]

viewPageNotFound : Config -> Locale -> String -> Html Msg
viewPageNotFound config locale currentPage =
    let
        modal : ModalContent Msg
        modal =
            { title = locale.pageNotFound
            , content = [ p [] [ text ("ID: " ++ currentPage) ] ]
            , buttons = [ choiceButton locale.backToHomeLabel "start" ]
            }
    in
    viewModal 
        { containerClass = errorTitleCls
        , titleClass = errorTitleCls 
        }
        locale 
        modal

viewItemPickedUp : Config -> Locale -> String -> Maybe String -> Html Msg
viewItemPickedUp config locale itemId mPreviousPage =
    let
        itemName = Items.getItemById itemId |> Maybe.map .name |> Maybe.withDefault "???"
        pickupText = String.replace "%s" itemName locale.itemPickedUp
        backPage = Maybe.withDefault "start" mPreviousPage

        modal =
            { title = locale.inventoryLabel
            , content = [ p [] [ text pickupText ] ]
            , buttons = [ choiceButton "Ок" backPage ]
            }
    in
    viewModal 
        { containerClass = pageTitleCls
        , titleClass = pageTitleCls
        }
        locale 
        modal

viewNormalPage : Config -> Locale -> Dict String Page -> WorldState -> Character -> String -> Html Msg
viewNormalPage config locale pages world character currentPage =
    case Dict.get currentPage pages of
        Just page ->
            let
                isGameOver = World.hasReachedThreshold currentPage world
                content =
                    case isGameOver of
                        True ->
                            Utils.extraInfo config locale world character currentPage
                                ++ Utils.gameOverInfo locale world character currentPage
                        False ->
                            [ h1 [ class pageTitleCls ] [ text page.title ]
                            , div [ class pageContentCls ] (viewParagraphs page.content)
                            ]
                            ++ Utils.extraInfo config locale world character currentPage
                            ++ [ viewChoices page.choices ]
            in
            novelContainer content

        Nothing ->
            viewPageNotFound config locale currentPage

viewPage : Config -> Locale -> Dict String Page -> WorldState -> Character -> Maybe String -> String -> Html Msg
viewPage config locale pages world character previousPage currentPage =
    case Items.getItemFromPage currentPage of
        Just itemId ->
            viewItemPickedUp config locale itemId previousPage
            
        Nothing ->
            if Dict.get currentPage pages == Nothing then
                viewPageNotFound config locale currentPage
            else
                viewNormalPage config locale pages world character currentPage

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
