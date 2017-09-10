module Model exposing (..)

import File exposing (File)
import Audio exposing (Audio)


type alias Model =
  { audios : List Audio
  }


init : Model
init =
  { audios = []
  }
