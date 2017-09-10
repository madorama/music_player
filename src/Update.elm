module Update exposing (update)

import Response exposing (..)
import MusicMetadata exposing (RawMetadata)
import Audio
import Model exposing (..)
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
