port module Modules.Ports exposing (..)

import Json.Decode exposing (Value)



--from Elm to JavaScript


port download : Value -> Cmd msg
