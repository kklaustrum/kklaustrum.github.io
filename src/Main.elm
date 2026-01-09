module Main exposing (main)

import Browser
import Html exposing (Html, div, h1, p, text, button)
import Html.Events exposing (onClick)
import Html.Attributes exposing (class)
import Http
import Json.Decode as D
import Pages exposing (PageData, decodeBook)
import Dict exposing (Dict)

type Model
  = Loading
  | Ready { currentPage : String, pages : Dict String PageData }
  | Error String

type Msg
  = PagesLoaded (Result Http.Error (Dict String PageData))
  | GoToPage String
  | ResetToStart

init : () -> (Model, Cmd Msg)
init _ =
  ( Loading
  , Http.get
      { url = "./book.json"
      , expect = Http.expectJson PagesLoaded decodeBook
      }
  )

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    PagesLoaded result ->
      case result of
        Ok pagesDict ->
          ( Ready { currentPage = "start", pages = pagesDict }, Cmd.none )
        Err error ->
          ( Error (Debug.toString error), Cmd.none )
    
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

viewPage : Dict String PageData -> String -> Html Msg
viewPage pages currentPage =
  case Dict.get currentPage pages of
    Just pageData -> 
      div [ class "novel-container" ]
        [ h1 [] [ text pageData.title ]
        , div [ class "page-content" ]
            (List.map (\paragraph -> 
                p [ class "paragraph" ] [ text paragraph ]
              ) pageData.content)
        , div [ class "choices" ]
            (List.map (\(label, pageId) ->
                button [ onClick (GoToPage pageId), class "choice-btn" ] 
                       [ text label ]
              ) pageData.choices)
        ]
    
    Nothing ->
      div [ class "novel-container error" ]
        [ h1 [] [ text "Страница не найдена" ]
        , p [] [ text ("ID: " ++ currentPage) ]
        , div [ class "choices" ]
            [ button [ onClick ResetToStart, class "reset-btn" ] 
                     [ text "На главную" ]
            ]
        ]

view : Model -> Html Msg
view model =
  case model of
    Loading ->
      div [ class "novel-container" ]
        [ h1 [] [ text "Загрузка книги..." ]
        ]
    
    Ready { currentPage, pages } ->
      viewPage pages currentPage
    
    Error errorMsg ->
      div [ class "novel-container error" ]
        [ h1 [] [ text "Ошибка" ]
        , p [] [ text errorMsg ]
        ]

subscriptions : Model -> Sub Msg
subscriptions _ = Sub.none

main : Program () Model Msg
main = Browser.element 
  { init = init, update = update, view = view, subscriptions = subscriptions }
