module Main exposing (main)

import Browser
import Dict exposing (Dict)
import Http
import Html exposing (Html)

-- modules
import Pages exposing (PageData)
import Decode exposing (decodeBook)
import Views exposing (viewLoading, viewError, viewPage)
import Messages exposing (Msg(..), goToPage, resetToStart)
import Locale exposing (Locale, is, en, ru)

defaultLocale : Locale
defaultLocale =
    is

-- ------------------------------------------------------------------
-- Model
-- ------------------------------------------------------------------
type Model
    = Loading Locale
    | Ready
        { locale : Locale
        , currentPage : String
        , pages : Dict String PageData
        }
    | Error Locale String

-- ------------------------------------------------------------------
-- Init
-- ------------------------------------------------------------------
init : () -> ( Model, Cmd Msg )
init _ =
    ( Loading defaultLocale
    , Http.get
        { url = "./book.json"
        , expect = Http.expectJson PagesLoaded decodeBook
        }
    )


-- ------------------------------------------------------------------
-- Update
-- ------------------------------------------------------------------
update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        PagesLoaded result ->
            case result of
                Ok pagesDict ->
                    ( Ready { locale = defaultLocale, currentPage = "start", pages = pagesDict }
                    , Cmd.none
                    )

                Err err ->
                    ( Error defaultLocale (httpErrorToString err), Cmd.none )

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

httpErrorToString : Http.Error -> String
httpErrorToString err =
    case err of
        Http.BadUrl u ->
            "Bad URL: " ++ u

        Http.Timeout ->
            "Timeout"

        Http.NetworkError ->
            "Network error"

        Http.BadStatus s ->
            "Bad status: " ++ String.fromInt s

        Http.BadBody b ->
            "Cannot parse body: " ++ b

-- ------------------------------------------------------------------
-- View routing
-- ------------------------------------------------------------------
view : Model -> Html Msg
view model =
    case model of
        Loading locale ->
            viewLoading locale

        Ready { locale, currentPage, pages } ->
            viewPage locale pages currentPage

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
