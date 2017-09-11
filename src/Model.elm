module Model exposing (..)

import List.Extra exposing (..)
import Audio exposing (Audio)


type alias Model =
  { audios : List Audio
  , selectAudioId : Int
  , playAudioId : Int
  , volume : Float
  , isPlay : Bool
  , isMute : Bool
  }


init : Model
init =
  { audios = []
  , selectAudioId = -1
  , playAudioId = -1
  , volume = 1
  , isPlay = False
  , isMute = False
  }


getPlayingAudio : Model -> Maybe Audio
getPlayingAudio model =
  model.audios !! model.playAudioId
