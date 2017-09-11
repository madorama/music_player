port module Ports exposing (..)

import Time exposing (Time)
import MusicMetadata exposing (MusicMetadata, RawMetadata)


port minimize : () -> Cmd msg


port dropAudios : (List RawMetadata -> msg) -> Sub msg


port play : (String, Time) -> Cmd msg


port pause : () -> Cmd msg


port audioUpdate : (Time -> msg) -> Sub msg


port audioEnded : (() -> msg) -> Sub msg


port setVolume : Float -> Cmd msg


port seek : Time -> Cmd msg
