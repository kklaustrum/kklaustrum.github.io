module Locale exposing (Locale, is, en, ru)

type alias Locale =
    { loading : String
    , errorTitle : String
    , errorMessage : String      -- will be filled dynamically at runtime
    , pageNotFound : String
    , backToHomeLabel : String
    }

is : Locale
is =
    { loading = "Hleð inn bókinni…"
    , errorTitle = "Villa"
    , errorMessage = ""
    , pageNotFound = "Síða fannst ekki"
    , backToHomeLabel = "Aftur á upphaf"
    }

en : Locale
en =
    { loading = "Loading book…"
    , errorTitle = "Error"
    , errorMessage = ""
    , pageNotFound = "Page not found"
    , backToHomeLabel = "Back to start"
    }

ru : Locale
ru =
    { loading = "Загрузка книги…"
    , errorTitle = "Ошибка"
    , errorMessage = ""
    , pageNotFound = "Страница не найдена"
    , backToHomeLabel = "На главную"
    }
