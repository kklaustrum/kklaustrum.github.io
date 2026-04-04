module Display exposing
    ( formatParamLabel, formatParamValue, formatParamShort, formatEffects
    , itemEffectHint, itemName
    )

import Dict exposing (Dict)
import Items exposing (getItemById, getItemEffects, getItemName)
import Locale exposing (Locale)
import Params exposing (Param, stringToParam, getParamLabel)

formatParamValue : Locale -> ( String, Int ) -> String
formatParamValue _ ( _, value ) =
    String.fromInt value

formatParamLabel : Locale -> ( String, Int ) -> String
formatParamLabel locale ( key, _ ) =
    stringToParam key
        |> Maybe.map (Params.getParamLabel locale)
        |> Maybe.withDefault key

formatParamShort : Locale -> ( String, Int ) -> String
formatParamShort locale entry =
    let
        label = formatParamLabel locale entry
        value = formatParamValue locale entry
        sign  = if Tuple.second entry > 0 then "+" else ""
    in
    label ++ sign ++ value

formatEffects : Locale -> Dict String Int -> String
formatEffects locale effects =
    Dict.toList effects
        |> List.map (formatParamShort locale)
        |> String.join " "

itemEffectHint : Locale -> String -> String
itemEffectHint locale itemId =
    Items.getItemById itemId
        |> Maybe.map Items.getItemEffects
        |> Maybe.map (formatEffects locale)
        |> Maybe.withDefault ""

itemName : String -> String
itemName =
    Items.getItemName
