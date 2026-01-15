module Main exposing (main)

import Browser
import Dict exposing (Dict)
import Http
import Html exposing (Html)

-- модули
import Pages exposing (PageData)
import Decode exposing (decodeBook)
import Views exposing (viewLoading, viewError, viewPage)
import Messages exposing (Msg(..), goToPage, resetToStart)

-- ------------------------------------------------------------------
-- Модель
-- ------------------------------------------------------------------
type Model
    = Loading
    | Ready { currentPage : String, pages : Dict String PageData }
    | Error String

-- ------------------------------------------------------------------
-- Инициализация
-- ------------------------------------------------------------------
init : () -> ( Model, Cmd Msg )
init _ =
    ( Loading
    , Http.get
        { url = "./book.json"
        , expect = Http.expectJson PagesLoaded decodeBook
        }
    )

-- ------------------------------------------------------------------
-- Обновление
-- ------------------------------------------------------------------
update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        PagesLoaded result ->
            case result of
                Ok pagesDict ->
                    ( Ready { currentPage = "start", pages = pagesDict }
                    , Cmd.none
                    )

                Err err ->
                    ( Error (httpErrorToString err), Cmd.none )

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
-- view | роутинг | whatever
-- ------------------------------------------------------------------
view : Model -> Html Msg
view model =
    case model of
        Loading ->
            viewLoading

        Ready { currentPage, pages } ->
            viewPage pages currentPage

        Error errMsg ->
            viewError errMsg

-- ------------------------------------------------------------------
-- Подписки
-- ------------------------------------------------------------------
subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none

-- ------------------------------------------------------------------
-- Точка входа
-- ------------------------------------------------------------------
main : Program () Model Msg
main =
    Browser.element
        { init = init
        , update = update
        , view = view
        , subscriptions = subscriptions
        }
