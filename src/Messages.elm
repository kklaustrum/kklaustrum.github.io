module Messages exposing (Msg(..), goToPage, resetToStart)

import Dict exposing (Dict)
import Http
import Pages exposing (PageData)

-- ------------------------------------------------------------------
-- Сообщения, которыми обмениваются все части приложения
-- ------------------------------------------------------------------
type Msg
    = PagesLoaded (Result Http.Error (Dict String PageData))
    | GoToPage String
    | ResetToStart

goToPage : String -> Msg
goToPage = GoToPage

resetToStart : Msg
resetToStart = ResetToStart
