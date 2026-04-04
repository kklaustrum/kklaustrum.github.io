module Views exposing (viewPage)

import Html exposing (Html)
import Utils exposing (Config)
import Locale exposing (Locale)
import World exposing (WorldState)
import Character exposing (Character)
import Veil exposing (Book)
import Messages exposing (Msg(..))
import Render exposing (..)
import Rules exposing (standardRules, evaluate)
import Types exposing (PageMode(..), RenderContext)

-- PageMode routing: NormalPage always has a book entry and merges extra
-- choices from passages. PassagePage is for code-only pages with non-empty
-- secret content. SecretPage was removed — it was conceptually identical
-- to PassagePage but without the book/passage distinction.
-- collectPassages falls back to autoBack when no outgoing passages exist.
viewPage : RenderContext -> Html Msg
viewPage ctx =
    let
        pageResult = evaluate (standardRules ctx.locale) ctx.world ctx.character ctx.currentPage

        content =
            case pageResult of
                NormalPage extraChoices ->
                    case Veil.getPage ctx.currentPage ctx.book of
                        Just page -> renderNormalPage ctx page extraChoices
                        Nothing   -> renderPageNotFound ctx

                PassagePage pageContent ->
                    renderPassagePage ctx pageContent

                GameOverPage ->
                    renderGameOver ctx

                ItemPickup itemName ->
                    renderItemPickup ctx itemName

                PageNotFound _ ->
                    renderPageNotFound ctx
    in
    pageContainer content
