module Main exposing (main)

import Browser
import Html exposing (Html)

import Views exposing (viewPage)
import Components exposing (viewLoading, viewError)
import Messages exposing (Msg(..))
import Locale exposing (Locale)
import HttpError exposing (ResourceError(..), resourceErrorToString)
import Veil exposing (loadContent, Page, Book, storyline)
import Utils exposing (defaultConfig, bookUrl)
import World exposing (WorldState, initWorld, startPage, setPendingItem)
import Character exposing (Character, initCharacter)
import Engine exposing (VisitResult, applyPageVisit)
import Types exposing (UIContext, GameContext)

-- ------------------------------------------------------------------
-- Model
-- ------------------------------------------------------------------
type alias ReadyData =
    { locale      : Locale
    , currentPage : String
    , storyline   : Book
    , world       : WorldState
    , character   : Character
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
    , currentPage = World.startPage
    , storyline   = book
    , world       = World.initWorld
    , character   = Character.initCharacter
    }

toUIContext : ReadyData -> UIContext
toUIContext data =
    { config = defaultConfig
    , locale = data.locale
    }

toGameContext : ReadyData -> GameContext
toGameContext data =
    { currentPage = data.currentPage
    , world       = data.world
    , book        = data.storyline
    }

updateReady : (ReadyData -> ReadyData) -> Model -> ( Model, Cmd Msg )
updateReady f model =
    case model of
        Ready data -> ( Ready (f data), Cmd.none )
        _ -> ( model, Cmd.none )

applyVisitResult : VisitResult -> String -> ReadyData -> ReadyData
applyVisitResult result pageId data =
    { data | currentPage = pageId, world = result.world, character = result.character }

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

        ReturnToStart ->
            updateReady (\data -> { data | currentPage = World.startPage, world = World.initWorld }) model

        ItemAction itemMsg ->
            updateReady (\data ->
                let
                    newCharacter = Engine.applyItemMsg itemMsg data.character
                    newWorld     = World.setPendingItem Nothing data.world
                in
                { data | character = newCharacter, world = newWorld }
            ) model

-- ------------------------------------------------------------------
-- View
-- ------------------------------------------------------------------
view : Model -> Html Msg
view model =
    case model of
        Loading locale ->
            viewLoading locale

        Ready data ->
            viewPage (toUIContext data)
                     (toGameContext data)
                     data.character

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
