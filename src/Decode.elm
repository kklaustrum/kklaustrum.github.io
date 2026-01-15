module Decode exposing (decodeBook)

import Pages exposing (PageData)
import Dict exposing (Dict)
import Json.Decode as D exposing (Decoder)

pageDecoder : Decoder PageData
pageDecoder =
    D.map3 PageData
        (D.field "title" D.string)
        (D.field "content" (D.list D.string))
        (D.field "choices"
            (D.list
                (D.map2 Tuple.pair
                    (D.index 0 D.string)
                    (D.index 1 D.string)
                )
            )
        )


decodeBook : Decoder (Dict String PageData)
decodeBook =
    D.dict pageDecoder
