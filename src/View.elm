module View exposing (view)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Color
import Material.Icons.Navigation as Icon
import View.Extra exposing (..)
import Mnlib.Html exposing (..)
import Audio exposing (Audio, DisplayElement (..))
import Model exposing (Model)
import Msg exposing (..)
import View.Player as Player exposing (..)


view : Model -> Html Msg
view model =
  fillBox
    [ prop "flex-direction" "column" ]
    [ viewTitleBar model
    , viewMain model
    ]


viewTitleBar : Model -> Html Msg
viewTitleBar model =
  let
    titleText =
      case Model.getPlayingAudio model of
        Nothing ->
          "MusicPlayer"

        Just audio ->
          Audio.makeAudioString [Title, Artist] audio
  in
  row
    [ class "titlebar"
    ]
    [ row
        [ class "title-wrap"
        ]
        [ div
            [ class "title" ]
            [ text titleText ]
        ]
    , row
        [ class "button"
        , onClick Minimize
        ]
        [ text "－" ]
    , row
        [ class "button"
        , class "close"
        , onClick CloseWindow
        ]
        [ Icon.close Color.white 16 ]
    ]


viewMain : Model -> Html Msg
viewMain model =
  column
    [ id "view-main"
    ]
    [ Player.view model
    , viewAudioList model
    ]


viewAudioList : Model -> Html Msg
viewAudioList model =
  column
    [ class "audio-list-wrap" ]
    [ column
        [ class "audio-list"]
        ( List.indexedMap (viewAudio model.selectAudioId) model.audios )
    ]


viewAudio : Int -> Int -> Audio -> Html Msg
viewAudio selectAudioId audioId audio =
  row
    [ class "audio"
    , onClick (ClickAudio audioId)
    , onDoubleClick (DoubleClickAudio audioId)
    , if selectAudioId == audioId then
        class "select"
      else
        class ""
    ]
    [ text <| Audio.makeAudioString [Title, Album, Artist] audio ]
