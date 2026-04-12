module Messages exposing (Msg(..), ItemMsg(..), goToPage, returnToStart, stashItem, equipItem, moveToStash, moveToEquipped)

import Veil exposing (Book)
import HttpError exposing (ResourceError)

-- ------------------------------------------------------------------
-- Inter-component messages
-- ------------------------------------------------------------------
type ItemMsg
    = Stash String
    | Equip String
    | MoveToStash String
    | MoveToEquipped String

type Msg
    = ContentLoaded (Result ResourceError Book)
    | GoToPage String
    | ReturnToStart
    | ItemAction ItemMsg
    | OpenCharacterScreen
    | CloseCharacterScreen

goToPage : String -> Msg
goToPage = GoToPage

returnToStart : Msg
returnToStart = ReturnToStart

contentLoaded : Result ResourceError Book -> Msg
contentLoaded = ContentLoaded

stashItem : String -> Msg
stashItem id = ItemAction (Stash id)

equipItem : String -> Msg
equipItem id = ItemAction (Equip id)

moveToStash : String -> Msg
moveToStash id = ItemAction (MoveToStash id)

moveToEquipped : String -> Msg
moveToEquipped id = ItemAction (MoveToEquipped id)
