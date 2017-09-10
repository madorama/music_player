module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Color
import Regex exposing (..)
import Response exposing (..)
import Material.Icons.Navigation as Icon
import View.Extra exposing (..)
import Mnlib.Html exposing (..)
import Model exposing (Model)
import Ports
import File exposing (File)
import Audio exposing (Audio)
import MusicMetadata exposing (MusicMetadata, RawMetadata)


type Msg
  = Minimize
  | DropAudios (List RawMetadata)


init : Response Model Msg
init =
  Model.init ! []


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


subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.batch
    [ Ports.dropAudios DropAudios ]


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


viewMain : Model -> Html msg
viewMain model =
  column
    [ id "view-main"
    ]
    [ viewAudioList model.audios
    ]


viewAudioList : List Audio -> Html msg
viewAudioList audios =
  column
    [ class "audio-list" ]
    (List.map viewAudio audios)


viewAudio : Audio -> Html msg
viewAudio audio =
  div
    [ class "audio" ]
    [ viewJust (\album -> text <| "[" ++ album ++ "] ") audio.album
    , viewJust (text << (flip (++)) " / ") audio.artist
    , text <| audio.name
    ]


main =
  Html.program
    { init = init
    , view = view
    , update = update
    , subscriptions = subscriptions
    }
