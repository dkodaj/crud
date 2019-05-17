module Serialize exposing (..)

import Json.Decode as Dec exposing (Decoder, field)
import Json.Encode as Enc exposing (Value, object)
import List exposing (map)
import Model exposing (Data)


decodeData : Decoder Data
decodeData =
    Dec.map3
        Data
        (field "name" Dec.string)
        (field "archEnemy" Dec.string)
        (field "loveInterest" Dec.string)


decodeJson : Decoder (List Data)
decodeJson =
    Dec.list decodeData


encodeData : Data -> Value
encodeData a =
    object
        [ ( "name", Enc.string a.name )
        , ( "archEnemy", Enc.string a.archEnemy )
        , ( "loveInterest", Enc.string a.loveInterest )
        ]


toJson : List Data -> Value
toJson a =
    Enc.list encodeData a
