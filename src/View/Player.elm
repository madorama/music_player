module View.Player exposing (..)

import Html exposing (..)
import Html.Attributes as Attr exposing (..)
import Html.Events as Ev exposing (..)
import View.Extra exposing (..)
import Color
import Material.Icons.Av as Icon
import Mnlib.Html exposing (..)
import Audio
import Model exposing (Model)
import Msg exposing (..)


view : Model -> Html Msg
view model =
  row
    [ class "audio-player" ]
    [ viewPlayButton model
    , viewVolume model
    , viewIf (always <| viewTime model) (model.playAudioId >= 0)
    ]


viewPlayButton : Model -> Html Msg
viewPlayButton model =
  let
    icon =
      if model.isPlay then
        Icon.pause Color.white 32
      else
        Icon.play_arrow Color.white 32
  in
    row
      [ onClick PlayPause
      , class "button"
      ]
      [ icon ]


viewVolume : Model -> Html Msg
viewVolume model =
  let
    icon =
      if model.isMute then
        Icon.volume_off Color.white 20

      else
        Icon.volume_up Color.white 20
  in

  row
    [ class "volume" ]
    [ div
        [ onClick ClickMute ]
        [ icon ]
    , input
        [ type_ "range"
        , Attr.max "1"
        , Attr.min "0"
        , Attr.step "0.01"
        , Attr.value <| toString model.volume
        , class "volume-bar"
        , onInput ChangeVolume
        ]
        []
    ]


viewTime : Model -> Html Msg
viewTime model =
  let
    audio =
      Model.getPlayingAudio model
        |> Maybe.withDefault Audio.init
  in
    row
      [ class "time" ]
      [ text <| Audio.audioTime audio
      , input
          [ type_ "range"
          , Attr.max <| toString audio.duration
          , Attr.min "0"
          , Attr.step "0.01"
          , Attr.value <| toString audio.nowTime
          , class "seek-bar"
          , onInput Seek
          ]
          []
      ]
