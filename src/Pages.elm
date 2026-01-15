module Pages exposing (PageData)

type alias PageData =
    { title   : String
    , content : List String
    , choices : List ( String, String )
    }
