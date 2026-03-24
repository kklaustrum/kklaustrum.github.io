module Main exposing (main)

import Browser
import Html exposing (Html)
import String

import Views exposing (viewPage)
import Components exposing (viewLoading, viewError)
import Messages exposing (Msg(..), goToPage, resetToStart)
import Locale exposing (Locale)
import HttpError exposing (resourceErrorToString)
import Veil exposing (loadContent, Page, Book, storyline, ResourceError(..))
import Utils exposing (defaultConfig, bookUrl)
import World exposing (WorldState, initWorld, addVisitIfNew)
import Character exposing (Character, initCharacter)
import Engine exposing (applyPageVisit, applyItemChoice)

-- ------------------------------------------------------------------
-- Model
-- ------------------------------------------------------------------
type alias ReadyData =
    { locale      : Locale
    , currentPage : String
    , storyline   : Book
    , world       : WorldState
    , character   : Character
    , pendingItem : Maybe String
    }

type Model
    = Loading Locale
    | Ready ReadyData
    | Error Locale String

-- ------------------------------------------------------------------
-- Helpers
-- ------------------------------------------------------------------
currentLocale : Model -> Locale
currentLocale model =
    case model of
        Loading loc -> loc
        Ready { locale } -> locale
        Error loc _ -> loc

-- ------------------------------------------------------------------
-- Init
-- ------------------------------------------------------------------
init : () -> ( Model, Cmd Msg )
init _ =
    let
        cfg = defaultConfig
    in
    ( Loading cfg.defaultLocale
    , loadContent (bookUrl cfg) ContentLoaded
    )

-- ------------------------------------------------------------------
-- Update
-- ------------------------------------------------------------------
update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ContentLoaded result ->
            case result of
                Ok book ->
                    ( Ready
                        { locale = defaultConfig.defaultLocale
                        , currentPage = "start"
                        , storyline = book
                        , world = World.initWorld
                        , character = Character.initCharacter
                        , pendingItem = Nothing
                        }
                    , Cmd.none
                    )

                Err err ->
                    let
                        errMsg = resourceErrorToString (currentLocale model) err
                    in
                    ( Error defaultConfig.defaultLocale errMsg, Cmd.none )

        GoToPage pageId ->
            case model of
                Ready data ->
                    let
                        result = Engine.applyPageVisit pageId data.currentPage data.world data.character
                    in
                    ( Ready
                        { data
                            | currentPage = pageId
                            , world = result.world
                            , character = result.character
                            , pendingItem = result.pendingItem
                        }
                    , Cmd.none
                    )

                Loading _ ->
                    ( model, Cmd.none )

                Error _ _ ->
                    ( model, Cmd.none )

        StashItem itemId ->
            case model of
                Ready data ->
                    ( Ready
                        { data
                            | character = applyItemChoice Character.addToStash itemId data.character
                            , pendingItem = Nothing
                        }
                    , Cmd.none
                    )

                _ ->
                    ( model, Cmd.none )

        EquipItem itemId ->
            case model of
                Ready data ->
                    ( Ready
                        { data
                            | character = applyItemChoice Character.equipItem itemId data.character
                            , pendingItem = Nothing
                        }
                    , Cmd.none
                    )

                _ ->
                    ( model, Cmd.none )

        ResetToStart ->
            case model of
                Ready data ->
                    ( Ready { data | currentPage = "start" }, Cmd.none )

                _ ->
                    ( model, Cmd.none )

-- ------------------------------------------------------------------
-- View
-- ------------------------------------------------------------------
view : Model -> Html Msg
view model =
    case model of
        Loading locale ->
            viewLoading locale

        Ready data ->
            let
                ctx =
                    { config = defaultConfig
                    , locale = data.locale
                    , world = data.world
                    , character = data.character
                    , currentPage = data.currentPage
                    , pendingItem = data.pendingItem
                    , book = data.storyline
                    }
            in
            viewPage ctx

        Error locale errMsg ->
            viewError locale errMsg

-- ------------------------------------------------------------------
-- Subscriptions
-- ------------------------------------------------------------------
subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none

-- ------------------------------------------------------------------
-- Entry point
-- ------------------------------------------------------------------
main : Program () Model Msg
main =
    Browser.element
        { init = init
        , update = update
        , view = view
        , subscriptions = subscriptions
        }
