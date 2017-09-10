port module Ports exposing (..)

import MusicMetadata exposing (MusicMetadata, RawMetadata)


port minimize : () -> Cmd msg


port dropAudios : (List RawMetadata -> msg) -> Sub msg
