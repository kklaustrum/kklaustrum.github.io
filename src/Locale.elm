module Locale exposing (Locale, is, en, ru)

type alias Locale =
    { loading : String
    , errorTitle : String
    , errorMessage : String      -- will be filled dynamically at runtime
    , pageNotFound : String
    , backToHomeLabel : String
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
    }

is =
    { loading = "Hleð inn bókinni…"
    , errorTitle = "Villa"
    , errorMessage = ""
    , pageNotFound = "Síða fannst ekki"
    , backToHomeLabel = "Aftur á upphaf"
    , httpBadUrl = "Röng slóð: "
    , httpTimeout = "Tími útrunninn"
    , httpNetworkError = "Netvilla"
    , httpBadStatus = "Ógild staða: %s"
    , httpBadBody = "Ekki hægt að lesa svar: %s"
    , debugCurrentPagePrefix = "Núverandi"
    , debugCurrentPageVisits = "heimsóknir:%s"
    , debugPathLabel = "Stígn"
    , gameOver = "Ganga í hringi. Teldu þetta leik lokinn."
    , paramsLabel = "Gildi"
    , inventoryLabel = "Vörubirgði"
    , noItemsLabel = "Engar vörur"
    , curiosity = "Forvitni"
    , endurance = "Úthald"
    , intellect = "Greind"
    , itemPickedUp = "Fann hlut: %s"
    }

en =
    { loading = "Loading book…"
    , errorTitle = "Error"
    , errorMessage = ""
    , pageNotFound = "Page not found"
    , backToHomeLabel = "Back to start"
    , httpBadUrl = "Bad URL: "
    , httpTimeout = "Timeout"
    , httpNetworkError = "Network error"
    , httpBadStatus = "Bad status: %s"
    , httpBadBody = "Cannot parse body: %s"
    , debugCurrentPagePrefix = "Current"
    , debugCurrentPageVisits = "visits:%s"
    , debugPathLabel = "Path"
    , gameOver = "Walking in circles. Consider this game over."
    , paramsLabel = "Parameters"
    , inventoryLabel = "Inventory"
    , noItemsLabel = "No items"
    , curiosity = "Curiosity"
    , endurance = "Endurance"
    , intellect = "Intellect"
    , itemPickedUp = "Picked up item: %s"
    }

ru =
    { loading = "Загрузка книги…"
    , errorTitle = "Ошибка"
    , errorMessage = ""
    , pageNotFound = "Страница не найдена"
    , backToHomeLabel = "На главную"
    , httpBadUrl = "Неверный URL: "
    , httpTimeout = "Таймаут"
    , httpNetworkError = "Сетевая ошибка"
    , httpBadStatus = "Неправильный статус: %s"
    , httpBadBody = "Не удалось разобрать тело: %s"
    , debugCurrentPagePrefix = "Текущая"
    , debugCurrentPageVisits = "посещений:%s"
    , debugPathLabel = "Путь"
    , gameOver = "Ходим по кругу. Считай, что game over."
    , paramsLabel = "Параметры"
    , inventoryLabel = "Инвентарь" 
    , noItemsLabel = "Нет предметов"
    , curiosity = "Любознательность"
    , endurance = "Выносливость"
    , intellect = "Интеллект"
    , itemPickedUp = "Получена вещь %s"
    }
