module Update exposing (update)

import List.Extra exposing (..)
import Response exposing (..)
import MusicMetadata exposing (RawMetadata)
import Audio exposing (Audio)
import Mnlib.Update as Update
import Model exposing (Model)
import Msg exposing (..)
import Ports


update : Msg -> Model -> Response Model Msg
update msg model =
  case msg of
    Minimize ->
      model
        |> withCmd (Ports.minimize ())

    DropAudios metas ->
      let
        audios =
          metas
            |> List.map MusicMetadata.getMetadata
            |> List.map Audio.fromMusicMetadata
      in
        { model
          | audios = List.append model.audios audios
        }
          |> withNone

    ClickAudio id ->
      { model
        | selectAudioId = id
      }
        |> withNone

    DoubleClickAudio id ->
      stopAudio model
        |> withNone
        |> Update.andThen (update <| ClickAudio id)
        |> Update.andThen (update PlayPause)

    PlayPause ->
      model
        |> playPause

    UpdateTime time ->
      let
        audio =
          Model.getPlayingAudio model
            |> Maybe.map (\a -> { a | nowTime = time })
            |> Maybe.withDefault Audio.init
      in
        { model
          | audios = updateIfIndex (\id -> id == model.playAudioId) (always audio) model.audios
        }
          |> withNone

    ClickMute ->
      let
        isMute =
          not model.isMute

        cmd =
          if isMute then
            Ports.setVolume 0

          else
            Ports.setVolume model.volume

      in
        { model
          | isMute = isMute
        }
          |> withCmd cmd

    ChangeVolume vol ->
      let
        volume =
          String.toFloat vol
            |> Result.withDefault 1
      in
        { model
          | volume = volume
          , isMute = False
        }
          |> withCmd (Ports.setVolume volume)

    Seek seekPos ->
      let
        time =
          String.toFloat seekPos
            |> Result.withDefault 0

        audio =
          Model.getPlayingAudio model
            |> Maybe.map (\a -> { a | nowTime = time })
            |> Maybe.withDefault Audio.init
      in
        { model
          | audios = updateIfIndex (\id -> id == model.playAudioId) (always audio) model.audios
        }
          |> withCmd (Ports.seek time)


playPause : Model -> Response Model Msg
playPause model =
  if model.isPlay then
    pauseAudio model
  else
    playAudio model

playAudio : Model -> Response Model Msg
playAudio model =
  let
    newModel =
      { model | playAudioId = model.selectAudioId }
        |>
          (\m ->
            if model.playAudioId /= model.selectAudioId then
              stopAudio m
            else
              m
          )

    audio =
      Model.getPlayingAudio newModel
        |> Maybe.withDefault Audio.init
  in
    newModel
      |> withCmd (Ports.play (audio.path, audio.nowTime))
      |> Update.updateModel (\m -> { m | isPlay = True })


pauseAudio : Model -> Response Model Msg
pauseAudio model =
  { model
    | isPlay = False
  }
    |> withCmd (Ports.pause ())


stopAudio : Model -> Model
stopAudio model =
  let
    audio =
      Model.getPlayingAudio model
        |> Maybe.map (\a -> { a | nowTime = 0 })
        |> Maybe.withDefault Audio.init
  in
    { model
      | audios = updateIfIndex (\id -> id == model.playAudioId) (always audio) model.audios
      , isPlay = False
    }
