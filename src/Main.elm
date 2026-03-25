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
import Engine exposing (VisitResult, applyPageVisit, applyStashChoice, applyEquipChoice)

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

initReady : Locale -> Book -> ReadyData
initReady locale book =
    { locale      = locale
    , currentPage = "start"
    , storyline   = book
    , world       = World.initWorld
    , character   = Character.initCharacter
    , pendingItem = Nothing
    }

updateReady : (ReadyData -> ReadyData) -> Model -> ( Model, Cmd Msg )
updateReady f model =
    case model of
        Ready data -> ( Ready (f data), Cmd.none )
        _ -> ( model, Cmd.none )

applyVisitResult : VisitResult -> String -> ReadyData -> ReadyData
applyVisitResult result pageId data =
    { data | currentPage = pageId, world = result.world, character = result.character, pendingItem = result.pendingItem }

withCharacter : Character -> Maybe String -> ReadyData -> ReadyData
withCharacter char pending data =
    { data | character = char, pendingItem = pending }

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
        ContentLoaded (Ok book) ->
            ( Ready (initReady defaultConfig.defaultLocale book), Cmd.none )

        ContentLoaded (Err err) ->
            ( Error defaultConfig.defaultLocale (resourceErrorToString (currentLocale model) err), Cmd.none )

        GoToPage pageId ->
            updateReady (\data ->
                applyVisitResult (Engine.applyPageVisit pageId data.currentPage data.world data.character) pageId data
            ) model

        StashItem itemId ->
            updateReady (\data ->
                withCharacter (applyStashChoice itemId data.character) Nothing data
            ) model

        EquipItem itemId ->
            updateReady (\data ->
                withCharacter (applyEquipChoice itemId data.character) Nothing data
            ) model

        ResetToStart ->
            updateReady (\data -> { data | currentPage = "start" }) model

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
