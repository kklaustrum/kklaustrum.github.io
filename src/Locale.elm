module Locale exposing (Locale, is, en)

type alias Locale =
    { loading : String
    , errorTitle : String
    , errorMessage : String      -- will be filled dynamically at runtime
    , pageNotFound : String
    , backToHomeLabel : String
    , goDeeperLabel : String
    , httpBadUrl : String
    , httpTimeout : String
    , httpNetworkError : String
    , httpBadStatus : String
    , httpBadBody : String
    , debugCurrentPagePrefix : String
    , debugCurrentPageVisits : String
    , debugPathLabel : String
    , gameOver : String
    , paramsLabel : String
    , inventoryLabel : String
    , noItemsLabel : String
    , curiosity : String
    , endurance : String
    , intellect : String
    , itemPickedUp : String
    , someRoomHeader : String
    , someRoomTxt : String
    , equip : String
    , stash : String
    , traits : String
    }

is =
    { loading = "Hleð inn bókinni…"
    , errorTitle = "Villa"
    , errorMessage = ""
    , pageNotFound = "Síða fannst ekki"
    , backToHomeLabel = "Aftur á upphaf"
    , goDeeperLabel = "Fara dýpra"
    , httpBadUrl = "Röng slóð: "
    , httpTimeout = "Tími útrunninn"
    , httpNetworkError = "Netvilla"
    , httpBadStatus = "Ógild staða: %s"
    , httpBadBody = "Ekki hægt að lesa svar: %s"
    , debugCurrentPagePrefix = "Núverandi"
    , debugCurrentPageVisits = "Heimsóknir"
    , debugPathLabel = "Stígn"
    , gameOver = "Ganga í hringi. Teldu þetta leik lokinn."
    , paramsLabel = "Gildi"
    , inventoryLabel = "Hlutir"
    , noItemsLabel = "Engar vörur"
    , curiosity = "Forvitni"
    , endurance = "Úthald"
    , intellect = "Greind"
    , itemPickedUp = "Fann hlut: %s"
    , someRoomHeader = "Búið herbergi"
    , someRoomTxt = "Þú fannst leynilega herbergið! Öll þín hlutir unnu saman til að afhjúpa þessa leyndarmál."
    , equip = "Búnaður"
    , stash = "Farangur"
    , traits = "Þættir"
    }

en =
    { loading = "Loading book…"
    , errorTitle = "Error"
    , errorMessage = ""
    , pageNotFound = "Page not found"
    , backToHomeLabel = "Back to start"
    , goDeeperLabel = "Go deeper"
    , httpBadUrl = "Bad URL: "
    , httpTimeout = "Timeout"
    , httpNetworkError = "Network error"
    , httpBadStatus = "Bad status: %s"
    , httpBadBody = "Cannot parse body: %s"
    , debugCurrentPagePrefix = "Current"
    , debugCurrentPageVisits = "Visits"
    , debugPathLabel = "Path"
    , gameOver = "Walking in circles. Consider this game over."
    , paramsLabel = "Parameters"
    , inventoryLabel = "Inventory"
    , noItemsLabel = "No items"
    , curiosity = "Curiosity"
    , endurance = "Endurance"
    , intellect = "Intellect"
    , itemPickedUp = "Picked up item: %s"
    , someRoomHeader = "Generated Room"
    , someRoomTxt = "You found the hidden chamber! All your items worked together to reveal this secret."
    , equip = "Equip"
    , stash = "Stash"
    , traits = "Traits"
    }
