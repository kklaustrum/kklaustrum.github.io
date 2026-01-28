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
    }
