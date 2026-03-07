module Render exposing
    ( renderItemPickup
    , renderPageNotFound
    , renderGameOver
    , renderNormalPage
    , renderSecretPage
    , pageLayout
    )

import Html exposing (Html)
import Dict exposing (Dict)
import Veil exposing (Page)
import Messages exposing (Msg(..))
import Locale exposing (Locale)
import World exposing (WorldState)
import Character exposing (Character)
import UiClasses exposing (..)

import Components exposing (..)
import Utils exposing (Config, debugData, formatItemPickup)
import Rules exposing (SecretContent)

-- ------------------------------------------------------------------
-- Render
-- ------------------------------------------------------------------
type alias HtmlList = List (Html Msg)

type alias PageContent =
    { title : Html Msg
    , content : HtmlList
    , choices : List (String, String)
    }

pageLayout : Config -> Locale -> WorldState -> Character -> String -> PageContent -> HtmlList
pageLayout config locale world character currentPage content =
    let
        debugInfo = debugData world currentPage
        debugSections =
            List.concat
                [ paramsSection locale (Character.allParamsData character)
                , inventorySection locale character.inventory
                , debugSection config.showDebugInfo locale debugInfo.currentPage debugInfo.visits debugInfo.path
                ]
    in
    List.concat
        [ [ content.title ]
        , content.content
        , debugSections
        , nonEmptyChoices content.choices
        ]

nonEmptyChoices : List (String, String) -> HtmlList
nonEmptyChoices choices =
    if List.isEmpty choices then [] else [ viewChoices choices ]

renderItemPickup : Config -> Locale -> String -> String -> HtmlList
renderItemPickup config locale itemName currentPage =
    [ titleHtml locale.inventoryLabel
    , paragraphNode (formatItemPickup locale itemName)
    , singleChoice "OK" currentPage
    ]

renderPageNotFound : Config -> Locale -> String -> HtmlList
renderPageNotFound config locale currentPage =
    [ errorTitleNode locale.pageNotFound
    , paragraphNode ("ID: " ++ currentPage)
    , singleChoice locale.backToHomeLabel "start"
    ]

renderGameOver : Config -> Locale -> WorldState -> Character -> String -> HtmlList
renderGameOver config locale world character currentPage =
    [ gameOverNode locale.gameOver ]

renderSecretPage : Config -> Locale -> SecretContent -> HtmlList
renderSecretPage config locale secretContent =
    [ titleHtml (secretContent.title locale)
    , paragraphNode (secretContent.content locale)
    , viewChoices (secretContent.choices locale)
    ]

-- -----------------------------------------------------------------
-- renderNormalPage
-- -----------------------------------------------------------------
renderNormalPage config locale page world character currentPage extraChoices =
    pageLayout config locale world character currentPage
        { title = titleHtml page.title
        , content = contentHtml page.content
        , choices = page.choices ++ extraChoices
        }
