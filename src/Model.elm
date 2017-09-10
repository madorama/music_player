module Model exposing (..)

import Audio exposing (Audio)


type alias Model =
  { audios : List Audio
  , selectAudio : Maybe Int
  }


init : Model
init =
  { audios = []
  , selectAudio = Nothing
  }
