module Audio exposing (..)


import MusicMetadata exposing (MusicMetadata)


type alias Audio =
  { path : String
  , name : String
  , album : Maybe String
  , artist : Maybe String
  , duration : Float
  }


fromMusicMetadata : MusicMetadata -> Audio
fromMusicMetadata musicMetadata =
  { path = musicMetadata.path
  , name = musicMetadata.title |> Maybe.withDefault musicMetadata.path
  , album = musicMetadata.album
  , artist = musicMetadata.artist
  , duration = musicMetadata.duration
  }
