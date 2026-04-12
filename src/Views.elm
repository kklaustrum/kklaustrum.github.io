module Views exposing (viewPage)

import Html exposing (Html)
import Character exposing (Character)
import Veil exposing (Book)
import Messages exposing (Msg(..))
import Render exposing (..)
import Rules exposing (standardRules, evaluate)
import Types exposing (PageMode(..), UIContext, GameContext, CharacterContext, ScreenMode(..))

toCharacterContext : Character -> CharacterContext
toCharacterContext char =
    { stash    = char.stash
    , equipped = char.equipped
    , params   = char.params
    , traits   = char.traits
    }

-- PageMode routing: NormalPage always has a book entry and merges extra
-- choices from passages. PassagePage is for code-only pages with non-empty
-- secret content. SecretPage was removed — it was conceptually identical
-- to PassagePage but without the book/passage distinction.
-- collectPassages falls back to autoBack when no outgoing passages exist.
viewPage : UIContext -> GameContext -> Character -> Html Msg
viewPage ui game char =
    case ui.screen of
        GameScreen      ->
            let
                pageResult = evaluate (standardRules ui.locale) game.world char game.currentPage
                inventory  = toCharacterContext char

                content =
                    case pageResult of
                        NormalPage extraChoices ->
                            case Veil.getPage game.currentPage game.book of
                                Just page -> renderNormalPage ui game inventory page extraChoices
                                Nothing   -> renderPageNotFound ui game

                        PassagePage pageContent ->
                            renderPassagePage ui game inventory pageContent

                        GameOverPage ->
                            renderGameOver ui

                        ItemPickup itemName ->
                            renderItemPickup ui itemName

                        PageNotFound _ ->
                            renderPageNotFound ui game
            in
            pageContainer content

        CharacterScreen ->
            pageContainer (renderCharacterScreen ui)
