module Audio exposing (..)

import Time exposing (Time)
import List.Extra exposing (..)
import Formatting as F exposing ((<>))
import MusicMetadata exposing (MusicMetadata)


type alias Audio =
  { path : String
  , name : String
  , album : Maybe String
  , artist : Maybe String
  , duration : Time
  , nowTime : Time
  }


init : Audio
init =
  { path = ""
  , name = ""
  , album = Nothing
  , artist = Nothing
  , duration = 0
  , nowTime = 0
  }


fromMusicMetadata : MusicMetadata -> Audio
fromMusicMetadata musicMetadata =
  { path = musicMetadata.path
  , name = musicMetadata.title |> Maybe.withDefault musicMetadata.path
  , album = musicMetadata.album
  , artist = musicMetadata.artist
  , duration = musicMetadata.duration
  , nowTime = 0
  }


type DisplayElement
  = Title
  | Artist
  | Album


timeFormat : Time -> String
timeFormat time =
  let
    hour =
      floor (time / 60 / 60)

    minute =
      floor (time / 60) % 60

    second =
      floor time % 60

    format =
      F.padLeft 2 '0' F.int <> F.s ":" <> F.padLeft 2 '0' F.int
  in
    if hour >= 1 then
      F.print (F.padLeft 2 '0' F.int <> F.s ":" <> format) hour minute second

    else
      F.print format minute second


audioTime : Audio -> String
audioTime audio =
  timeFormat audio.nowTime ++ "/" ++ timeFormat audio.duration


makeAudioString : List DisplayElement -> Audio -> String
makeAudioString dispElements audio =
  let
    textJust f maybe =
      maybe
        |> Maybe.map f
        |> Maybe.withDefault ""

    dispText dispElem f =
      if List.any (\el -> el == dispElem) dispElements then
        f

      else
        ""

    title =
      dispText Title audio.name

    album =
      dispText Album <| textJust (\album -> "[" ++ album ++ "]") audio.album

    artist =
      dispText Artist <| textJust ((flip (++)) " / " ) audio.artist
  in
    album ++ artist ++ audio.name
