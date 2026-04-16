module Main exposing (main)

import Browser
import Html exposing (Html)

import Views exposing (viewPage)
import Components exposing (viewLoading, viewError)
import Messages exposing (Msg(..), ItemMsg(..))
import Locale exposing (Locale)
import HttpError exposing (ResourceError(..), resourceErrorToString)
import Veil exposing (loadContent, Page, Book, storyline)
import Utils exposing (defaultConfig, bookUrl)
import World exposing (WorldState, initWorld, startPage)
import Character exposing (Character, initCharacter)
import Engine exposing (VisitResult, applyPageVisit)
import Types exposing (UIContext, GameContext, ScreenMode(..))

-- ------------------------------------------------------------------
-- Model
-- ------------------------------------------------------------------
type alias ReadyData =
    { locale      : Locale
    , currentPage : String
    , storyline   : Book
    , world       : WorldState
    , character   : Character
    , screen      : ScreenMode
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
    , screen      = GameScreen
    }

toUIContext : ReadyData -> UIContext
toUIContext data =
    { config = defaultConfig
    , locale = data.locale
    , screen = data.screen
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

applyVisitResult : String -> ReadyData -> ReadyData
applyVisitResult pageId data =
    let
        visitResult = Engine.applyPageVisit pageId data.currentPage data.world data.character
    in
    { data | currentPage = pageId, world = visitResult.world, character = visitResult.character }

applyItemAction : ItemMsg -> ReadyData -> ReadyData
applyItemAction itemMsg data =
    { data | character = Engine.applyItemMsg itemMsg data.character }

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
            updateReady (applyVisitResult pageId) model

        ReturnToStart ->
            updateReady (\data -> { data | currentPage = World.startPage, world = World.initWorld }) model

        ItemAction itemMsg ->
            updateReady (applyItemAction itemMsg) model

        OpenCharacterScreen ->
            updateReady (\data -> { data | screen = CharacterScreen }) model

        CloseCharacterScreen ->
            updateReady (\data -> { data | screen = GameScreen }) model

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
