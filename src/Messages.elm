module Messages exposing (Msg(..), goToPage, resetToStart, stashItem, equipItem)

import Veil exposing (Book, ResourceError)

-- ------------------------------------------------------------------
-- Сообщения, которыми обмениваются все части приложения
-- ------------------------------------------------------------------
type Msg
    = ContentLoaded (Result ResourceError Book)
    | GoToPage String
    | ResetToStart
    | StashItem String
    | EquipItem String

goToPage : String -> Msg
goToPage = GoToPage

resetToStart : Msg
resetToStart = ResetToStart

contentLoaded : Result ResourceError Book -> Msg
contentLoaded = ContentLoaded

stashItem : String -> Msg
stashItem = StashItem

equipItem : String -> Msg
equipItem = EquipItem
