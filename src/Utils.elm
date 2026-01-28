module Utils exposing
    ( Config
    , defaultConfig
    , bookUrl
    , markdownUrl
    , isBookUrl
    )

import Locale exposing (Locale, is)

type alias Config =
    { defaultLocale : Locale
    , bookUrl : String
    , markdownUrl : String
    }

defaultConfig : Config
defaultConfig =
    { defaultLocale = is
    , bookUrl = "./book.json"
    , markdownUrl = "./book.md"
    }

bookUrl : Config -> String
bookUrl cfg =
    cfg.bookUrl

markdownUrl : Config -> String
markdownUrl cfg =
    cfg.markdownUrl

isBookUrl : String -> Config -> Bool
isBookUrl url cfg =
    url == cfg.bookUrl
