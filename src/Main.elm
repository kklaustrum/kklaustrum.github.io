module Main exposing (main)

import Browser
import Dict exposing (Dict)
import Html exposing (Html)
import String

import Views exposing (viewLoading, viewError, viewPage)
import Messages exposing (Msg(..), goToPage, resetToStart)
import Locale exposing (Locale)
import HttpError exposing (httpErrorToString)
import Veil exposing (loadContent, Page, Book, pageset, ResourceError(..))
import Utils exposing (defaultConfig, bookUrl)

-- ------------------------------------------------------------------
-- Model
-- ------------------------------------------------------------------
type Model
    = Loading Locale
    | Ready
        { locale : Locale
        , currentPage : String
        , pageset : Dict String Page
        }
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

resourceErrorToString : Locale -> ResourceError -> String
resourceErrorToString locale (HttpError httpErr) =
    httpErrorToString locale httpErr

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
                    ( Ready { locale = defaultConfig.defaultLocale
                           , currentPage = "start"
                           , pageset = Veil.pageset book
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
                    ( Ready { data | currentPage = pageId }, Cmd.none )

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

        Ready { locale, currentPage, pageset } ->
            viewPage locale pageset currentPage

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
