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
    , anotherRoomHeader : String
    , anotherRoomTxt : String
    , goingDeeperHeader : String
    , goingDeeperTxt : String
    , equip : String
    , stash : String
    , equipLabel : String
    , stashLabel : String
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
    , debugCurrentPagePrefix = "Staður"
    , debugCurrentPageVisits = "Heimsóknir"
    , debugPathLabel = "Leið"
    , gameOver = "Þú gengur í hringi. Leiknum er lokið."
    , paramsLabel = "Gildi"
    , inventoryLabel = "Hlutir"
    , noItemsLabel = "Engar vörur"
    , curiosity = "Forvitni"
    , endurance = "Úthald"
    , intellect = "Greind"
    , itemPickedUp = "Fann hlut: %s"
    , someRoomHeader = "Búið herbergi"
    , someRoomTxt = "Þú fannst leynilega herbergið! Öll þín hlutir unnu saman til að afhjúpa þessa leyndarmál."
    , anotherRoomHeader = "Annað leynilegt herbergi."
    , anotherRoomTxt = "Þú fannst leyndan gang!"
    , goingDeeperHeader = "Fara dýpar inn"
    , goingDeeperTxt = "Eitthvað svoleiðis."
    , equip = "Búnaður"
    , stash = "Geymsla"
    , equipLabel = "Búna"
    , stashLabel = "Geyma"
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
    , anotherRoomHeader = "Another Secret Room"
    , anotherRoomTxt = "You found a hidden passage!"
    , goingDeeperHeader = "Going deeper"
    , goingDeeperTxt = "Sort of."
    , equip = "Equip"
    , stash = "Stash"
    , equipLabel = "Equip"
    , stashLabel = "Stash"
    , traits = "Traits"
    }
