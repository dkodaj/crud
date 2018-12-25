module Modules.Request exposing (..)

import Http exposing (jsonBody, post, send)
import Json.Decode as Dec
import Modules.Model exposing (Data, Msg(..), emptyForm)
import Modules.Serialize exposing (decodeJson, encodeData)


create : Data -> Cmd Msg
create formData =
    requestSchema "/create" formData


decodeServerMsg =
    Dec.field "ServerMsg" Dec.string


delete : Data -> Cmd Msg
delete formData =
    requestSchema "/delete" formData


fetchAllRows : Cmd Msg
fetchAllRows =
    read emptyForm


read : Data -> Cmd Msg
read formData =
    send IncomingData <|
        post "/read" (jsonBody <| encodeData formData) decodeJson


requestSchema : String -> Data -> Cmd Msg
requestSchema uri formData =
    send IncomingServerMsg <|
        post uri (jsonBody <| encodeData formData) decodeServerMsg


updateDB : Data -> Cmd Msg
updateDB formData =
    requestSchema "/update" formData
