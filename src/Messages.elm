module Messages exposing (Msg(..), goToPage, resetToStart)

import Veil exposing (Book, ResourceError)

-- ------------------------------------------------------------------
-- Сообщения, которыми обмениваются все части приложения
-- ------------------------------------------------------------------
type Msg
    = ContentLoaded (Result ResourceError Book)
    | GoToPage String
    | ResetToStart

goToPage : String -> Msg
goToPage = GoToPage

resetToStart : Msg
resetToStart = ResetToStart
