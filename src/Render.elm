module Render exposing
    ( renderItemPickup, renderPageNotFound, renderGameOver, renderPassagePage,renderNormalPage
    , renderCharacterScreen
    , pageLayout, pageContainer
    )

import Dict
import Html exposing (Html)
import Messages exposing (Msg(..), moveToStash, moveToEquipped)
import Locale exposing (Locale)
import UiClasses exposing (..)
import Components exposing (..)
import Utils exposing (Config, formatItemPickup, listWhen)
import Types exposing (Page, PageContent, ExtraChoices, UIContext, GameContext, Character, ItemAction, EquippedItems(..), StashItems(..), DebugInfo)
import Display exposing (itemEffectHint, itemName)

-- HtmlList and PageLayout stay here: moving them to Types would pollute a data-only module with Html/Msg dependencies.
type alias HtmlList = List (Html Msg)

type alias PageLayout =
    { title : Html Msg
    , content : HtmlList
    , choices : List (String, String)
    }

debugData : GameContext -> DebugInfo
debugData game =
    { currentPage = game.currentPage
    , visits      = Dict.get game.currentPage game.world.visitCounts |> Maybe.withDefault 0
    , path        = List.reverse game.world.visitHistory
    }

pageContainer : HtmlList -> Html Msg
pageContainer content =
    Components.novelContainer content

toEquippedItem : Locale -> String -> ItemAction
toEquippedItem locale id =
    { id     = id
    , hint   = Display.itemEffectHint locale id
    , action = Messages.moveToStash id
    }

toStashItem : Locale -> String -> ItemAction
toStashItem locale id =
    { id     = id
    , hint   = Display.itemEffectHint locale id
    , action = Messages.moveToEquipped id
    }

pageLayout : UIContext -> GameContext -> Character -> PageLayout -> HtmlList
pageLayout ui game inventory content =
    let
        debugInfo = debugData game
        { locale, config } = ui
        { stash, equipped, params } = inventory
        { showDebugInfo } = config

        equippedItems =
            equipped
                |> List.map (toEquippedItem locale)
                |> EquippedItems

        stashItems =
            stash
                |> List.map (toStashItem locale)
                |> StashItems
    in
    List.concat
        [ [ pageHeader ]
        , [ content.title ]
        , content.content
        , [ statsLayout
            (paramsSection locale params)
            (inventorySection locale equippedItems stashItems)
            (currentPageSection showDebugInfo locale debugInfo.currentPage)
            (currentVisitsSection showDebugInfo locale debugInfo.visits)
            (pathSection showDebugInfo locale debugInfo.path)
        ]
        , nonEmptyChoices content.choices
        ]

nonEmptyChoices : ExtraChoices -> HtmlList
nonEmptyChoices choices =
    listWhen (not (List.isEmpty choices)) (viewChoices choices)

renderItemPickup : UIContext -> String -> HtmlList
renderItemPickup ui itemId =
    [ titleHtml ui.locale.inventoryLabel
    , paragraphNode (formatItemPickup ui.locale (Display.itemName itemId))
    , itemChoiceButtons ui.locale itemId
    ]

renderPageNotFound : UIContext -> GameContext -> HtmlList
renderPageNotFound ui game =
    [ errorTitleNode ui.locale.pageNotFound
    , paragraphNode ("ID: " ++ game.currentPage)
    , singleChoice ui.locale.backToHomeLabel "start"
    ]

renderGameOver : UIContext -> HtmlList
renderGameOver ui =
    [ gameOverNode ui.locale.gameOver
    , actionButton ui.locale.backToHomeLabel ReturnToStart
    ]

renderPassagePage : UIContext -> GameContext -> Character -> PageContent -> HtmlList
renderPassagePage ui game inventory pc =
    pageLayout ui game inventory
        { title   = titleHtml pc.title
        , content = contentHtml [ pc.content ]
        , choices = pc.choices
        }

renderNormalPage : UIContext -> GameContext -> Character -> Page -> ExtraChoices -> HtmlList
renderNormalPage ui game inventory page extraChoices =
    pageLayout ui game inventory
        { title   = titleHtml page.title
        , content = contentHtml page.content
        , choices = page.choices ++ extraChoices
        }

renderCharacterScreen : UIContext -> Character -> HtmlList
renderCharacterScreen ui char =
    traitsSection ui.locale char.traits
    ++ [ actionButton ui.locale.backToHomeLabel CloseCharacterScreen ]
