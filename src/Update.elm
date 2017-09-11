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

    CloseWindow ->
      model
        |> withCmd (Ports.close ())

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
      playPause model

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
      in
        { model
          | isMute = isMute
        }
          |> withCmd (Ports.setVolume <| if isMute then 0 else model.volume)

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


    AudioEnded () ->
      let
        newSelectAudioId =
          model.playAudioId + 1
      in
        if newSelectAudioId >= List.length model.audios then
          stopAudio model
            |> withNone

        else
          update (DoubleClickAudio newSelectAudioId) model


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
          if model.playAudioId /= model.selectAudioId then
            stopAudio

          else
            identity

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
