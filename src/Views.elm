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
import Types exposing (PageMode(..))

viewPage : Config -> Locale -> Book -> WorldState -> Character -> String -> Html Msg
viewPage config locale book world character currentPage =
    let
        ctx =
            { config = config
            , locale = locale
            , world = world
            , character = character
            , currentPage = currentPage
            }

        pageResult = evaluate (standardRules locale) world character currentPage

        content =
            case pageResult of
                NormalPage extraChoices ->
                    case Veil.getPage currentPage book of
                        Just page -> renderNormalPage ctx page extraChoices
                        Nothing -> renderPageNotFound ctx

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
