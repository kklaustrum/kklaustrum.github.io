module Components exposing
    ( novelContainer, pageHeader, characterScreenButton
    , statsGrid, statsLayout
    , actionButton, choiceButton
    , viewChoices
    , titleHtml
    , contentHtml
    , viewParagraphs
    , viewLoading
    , viewError
    , paramsSection, inventorySection
    , currentPageSection, currentVisitsSection, pathSection
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
import Utils exposing (formatParamsData, formatInventoryData, formatEquippedData, formatStashData, joinList, listWhen)
import Messages exposing (Msg(..), stashItem, equipItem)
import Types exposing (ItemAction, EquippedItems(..), StashItems(..), ScreenMode(..))
import Display exposing (formatParamLabel, formatParamValue)

-- -----------------------------------------------------------------
-- Low-level helpers
-- -----------------------------------------------------------------
labeledSpan : String -> String -> Html msg
labeledSpan cls content =
    span [ class cls ] [ text content ]

sectionHeader : String -> Html msg
sectionHeader content =
    p [ class sectionHeaderCls ] [ text content ]

-- A row with a tagged label on the left and a plain value on the right.
infoRow : String -> String -> Html msg
infoRow label value =
    div [ class inventoryRowCls ]
        [ labeledSpan rowTagCls label
        , span [ class breakWordsCls ] [ text value ]
        ]

infoSection : List (Html msg) -> List (Html msg) -> Html msg
infoSection header rows =
    div [ class infoSectionCls ]
        [ div [] header
        , div [ class infoRowsGridCls ] rows
        ]

-- -----------------------------------------------------------------
-- UI components
-- -----------------------------------------------------------------
toggleBadge : String -> ItemAction -> Html Msg
toggleBadge arrow item =
    span [ class toggleBadgeCls ]
        [ span [] [ text item.id ]
        , span
            [ onClick item.action
            , Html.Attributes.title (arrow ++ " " ++ item.hint)
            , class itemArrowCls
            ]
            [ text arrow ]
        ]

toggleRow : String -> String -> List ItemAction -> Html Msg
toggleRow rowTag arrow items =
    div [ class inventoryRowCls ]
        [ labeledSpan rowTagCls rowTag
        , span [ class toggleRowCls ]
            (List.map (toggleBadge arrow) items)
        ]

novelContainer : List (Html msg) -> Html msg
novelContainer children =
    div [ class novelContainerCls ] children

pageHeader : Html Msg
pageHeader =
    div [ class pageHeaderCls ]
        [ characterScreenButton ]

characterScreenButton : Html Msg
characterScreenButton =
    button
        [ class glyphButtonCls
        , onClick OpenCharacterScreen
        , Html.Attributes.title "Character"
        ]
        [ text "∴" ]

statsGrid : List (Html msg) -> List (Html msg) -> Html msg
statsGrid left right =
    div [ class statsGridCls ]
        [ div [] left
        , div [] right
        ]

statsLayout : List (Html msg) -> List (Html msg) -> List (Html msg) -> List (Html msg) -> List (Html msg) -> Html msg
statsLayout topLeft topRight bottomLeft bottomRight footer =
    div [ class statsGridCls ]
        [ div [] topLeft
        , div [] topRight
        , div [] bottomLeft
        , div [] bottomRight
        , div [ class fullWidthCellCls ] footer
        ]

actionButton : String -> Msg -> Html Msg
actionButton label msg =
    div [ class centeredChoiceCls ]
        [ button [ onClick msg, class choiceBtnCls ] [ text label ] ]

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

viewError : Locale -> String -> Html Msg
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

currentPageSection : Bool -> Locale -> String -> List (Html msg)
currentPageSection showDebug locale currentPage =
    listWhen showDebug <|
        infoSection []
            [ infoRow locale.debugCurrentPagePrefix currentPage ]

currentVisitsSection : Bool -> Locale -> Int -> List (Html msg)
currentVisitsSection showDebug locale visits =
    listWhen showDebug <|
        infoSection []
            [ infoRow locale.debugCurrentPageVisits (String.fromInt visits) ]

pathSection : Bool -> Locale -> List String -> List (Html msg)
pathSection showDebug locale path =
    listWhen showDebug <|
        infoSection []
            [ infoRow locale.debugPathLabel (Utils.joinList path) ]

paramRow : Locale -> ( String, Int ) -> Html msg
paramRow locale entry =
    infoRow (formatParamLabel locale entry) (formatParamValue locale entry)

paramsSection : Locale -> Dict String Int -> List (Html msg)
paramsSection locale params =
    [ infoSection
        [ sectionHeader (formatParamsData locale) ]
        (List.map (paramRow locale) (Dict.toList params))
    ]

itemBadge : String -> String -> Msg -> Html Msg
itemBadge arrow itemId msg =
    span []
        [ span [] [ text itemId ]
        , span
            [ onClick msg
            , Html.Attributes.title (arrow ++ " move")
            , class itemArrowCls
            ]
            [ text arrow ]
        ]

inventorySection : Locale -> EquippedItems -> StashItems -> List (Html Msg)
inventorySection locale (EquippedItems equipped) (StashItems stash) =
    [ infoSection
        [ sectionHeader locale.inventoryLabel ]
        [ toggleRow locale.equip "▼" equipped
        , toggleRow locale.stash "▲" stash
        ]
    ]

gameOverSection : Locale -> Bool -> List (Html msg)
gameOverSection locale isGameOver =
    listWhen isGameOver (gameOverNode locale.gameOver)

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
