module Messages exposing (Msg(..), goToPage, resetToStart, itemPickedUp)

import Veil exposing (Book, ResourceError)

-- ------------------------------------------------------------------
-- Сообщения, которыми обмениваются все части приложения
-- ------------------------------------------------------------------
type Msg
    = ContentLoaded (Result ResourceError Book)
    | GoToPage String
    | ResetToStart
    | ItemPickedUp String

goToPage : String -> Msg
goToPage = GoToPage

resetToStart : Msg
resetToStart = ResetToStart

contentLoaded : Result ResourceError Book -> Msg
contentLoaded = ContentLoaded

itemPickedUp : String -> Msg
itemPickedUp = ItemPickedUp
