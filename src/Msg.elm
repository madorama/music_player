module Msg exposing (..)

import Time exposing (Time)
import MusicMetadata exposing (RawMetadata)


type Msg
  = Minimize
  | DropAudios (List RawMetadata)
  | ClickAudio Int
  | DoubleClickAudio Int
  | PlayPause
  | UpdateTime Time
  | ClickMute
  | ChangeVolume String
  | Seek String
