module Veil exposing 
    ( loadContent
    , Page
    , Book
    , pageset
    , ResourceError(..)
    )

import Http exposing (expectJson, emptyBody, Error)
import Json.Decode as D exposing (Decoder)
import Dict exposing (Dict)

type alias Page =
    { title : String
    , content : List String
    , choices : List (String, String)
    }

type Book
    = JsonBook (Dict String Page)

type ResourceError
    = HttpError Error

pageset : Book -> Dict String Page
pageset book =
    case book of
        JsonBook dict -> dict

loadContent : String -> (Result ResourceError Book -> msg) -> Cmd msg
loadContent url toMsg =
    if String.endsWith ".json" url then
        loadJsonBook toMsg url
    else
        Cmd.none

loadJsonBook : (Result ResourceError Book -> msg) -> String -> Cmd msg
loadJsonBook toMsg url =
    Http.request
        { method = "GET"
        , headers = []
        , url = url
        , body = emptyBody
        , expect = expectJson (handleJsonResult toMsg) jsonBookDecoder
        , timeout = Nothing
        , tracker = Nothing
        }

pageDecoder : Decoder Page
pageDecoder =
    D.map3 Page
        (D.field "title" D.string)
        (D.field "content" (D.list D.string))
        (D.field "choices"
            (D.list
                (D.map2 Tuple.pair
                    (D.index 0 D.string)
                    (D.index 1 D.string)
                )
            )
        )

jsonBookDecoder : Decoder (Dict String Page)
jsonBookDecoder = D.dict pageDecoder

handleJsonResult :
    (Result ResourceError Book -> msg)
    -> Result Error (Dict String Page)
    -> msg
handleJsonResult toMsg result =
    result
        |> Result.map JsonBook
        |> Result.mapError HttpError
        |> toMsg
