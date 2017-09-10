module Msg exposing (..)

import MusicMetadata exposing (RawMetadata)


type Msg
  = Minimize
  | DropAudios (List RawMetadata)
