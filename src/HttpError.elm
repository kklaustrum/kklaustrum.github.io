module HttpError exposing (httpErrorToString)

import Http exposing (Error)
import Locale exposing (Locale)

httpErrorToString : Locale -> Error -> String
httpErrorToString locale err =
    case err of
        Http.BadUrl u ->
            locale.httpBadUrl ++ u

        Http.Timeout ->
            locale.httpTimeout

        Http.NetworkError ->
            locale.httpNetworkError

        Http.BadStatus s ->
            -- в локали хранится шаблон "Bad status: %s"
            String.replace "%s" (String.fromInt s) locale.httpBadStatus

        Http.BadBody b ->
            -- в локали шаблон "Cannot parse body: %s"
            String.replace "%s" b locale.httpBadBody
