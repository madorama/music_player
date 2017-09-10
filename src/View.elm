module View exposing (view)

import Html exposing (..)
import Html.Attributes as Attr exposing (..)
import Html.Events as Ev exposing (..)
import Color
import Material.Icons.Navigation as Icon
import View.Extra exposing (..)
import Mnlib.Html exposing (..)
import Audio exposing (Audio)
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
  row
    [ class "titlebar"
    ]
    [ row
        [ class "title"
        ]
        [ text "Music player" ]
    , row
        [ class "button"
        , onClick Minimize
        ]
        [ text "－" ]
    , row
        [ class "button"
        , class "close"
        ]
        [ Icon.close Color.white 16 ]
    ]


viewMain : Model -> Html Msg
viewMain model =
  column
    [ id "view-main"
    ]
    [ Player.view model
    , viewAudioList model.audios
    ]


viewAudioList : List Audio -> Html Msg
viewAudioList audios =
  column
    [ class "audio-list" ]
    ( List.map viewAudio audios )


viewAudio : Audio -> Html Msg
viewAudio audio =
  div
    [ class "audio" ]
    [ viewJust (\album -> text <| "[" ++ album ++ "] ") audio.album
    , viewJust (text << (flip (++)) " / ") audio.artist
    , text <| audio.name
    ]
