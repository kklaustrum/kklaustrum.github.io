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

viewPage : RenderContext -> Html Msg
viewPage ctx =
    let
        pageResult = evaluate (standardRules ctx.locale) ctx.world ctx.character ctx.currentPage

        content =
            case pageResult of
                NormalPage extraChoices ->
                    case ctx.world.pendingItem of
                        Just itemId -> renderItemPickup ctx itemId
                        Nothing ->
                            case Veil.getPage ctx.currentPage ctx.book of
                                Just page -> renderNormalPage ctx page extraChoices
                                Nothing   -> renderPageNotFound ctx

                SecretPage secretContent ->
                    renderSecretPage ctx secretContent

                GameOverPage ->
                    renderGameOver ctx

                ItemPickup itemName ->
                    renderItemPickup ctx itemName

                PageNotFound _ ->
                    renderPageNotFound ctx
    in
    pageContainer content
