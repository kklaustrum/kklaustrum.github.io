module Views exposing (viewPage)

import Dict exposing (Dict)
import Html exposing (Html)
import Components exposing (novelContainer)
import Utils exposing (Config)
import Locale exposing (Locale)
import World exposing (WorldState)
import Character exposing (Character)
import Veil exposing (Page)
import Messages exposing (Msg(..))
import Render exposing (..)
import Rules exposing (standardRules, evaluate)
import Types exposing (PageMode(..))

viewPage : Config -> Locale -> Dict String Page -> WorldState -> Character -> String -> Html Msg
viewPage config locale storyline world character currentPage =
    let
        pageResult = evaluate (standardRules locale) world character currentPage
        
        content =
            case pageResult of
                NormalPage extraChoices -> 
                    getNormalPageOrNotFound config locale storyline world character currentPage extraChoices
                
                SecretPage secretContent ->
                    renderSecretPage config locale secretContent
                
                GameOverPage -> 
                    renderGameOver config locale world character currentPage
                
                ItemPickup itemName ->
                    renderItemPickup config locale itemName currentPage
                
                PageNotFound _ -> 
                    renderPageNotFound config locale currentPage
    in
    Components.novelContainer content

getNormalPageOrNotFound : Config -> Locale -> Dict String Page -> WorldState -> Character -> String -> List (String, String) -> List (Html Msg)
getNormalPageOrNotFound config locale storyline world character currentPage extraChoices =
    case Dict.get currentPage storyline of
        Just page -> 
            renderNormalPage config locale page world character currentPage extraChoices
        Nothing -> 
            renderPageNotFound config locale currentPage
