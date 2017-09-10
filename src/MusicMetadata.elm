module MusicMetadata exposing (..)


type alias NumberData =
  { no : Maybe Int
  , of_ : Maybe Int
  }


type alias MusicMetadata =
  { album : Maybe String
  , artist : Maybe String
  , artists : List String
  , genres : List String
  , title : Maybe String
  , disk : NumberData
  , track : NumberData
  , bpm : Maybe Float
  , duration : Float
  , path : String
  }


type alias RawMetadata =
  { tagType : String
  , metadata : MusicMetadata
  , rawData : List RawData
  }


type alias RawData =
  { id : String
  , value : String
  }


getMetadata : RawMetadata -> MusicMetadata
getMetadata raw =
  case raw.tagType of
    "exif" ->
      getExifMetadata raw.metadata.path raw.metadata.duration raw.rawData

    otherwise ->
      raw.metadata


getExifMetadata : String -> Float -> List { id : String, value : String } -> MusicMetadata
getExifMetadata path duration rawData =
  let
    artist =
      List.filter ((==) "IART" << .id) rawData
        |> List.map .value
        |> List.head

    genres =
      List.filter ((==) "IGNR" << .id) rawData
        |> List.map .value

    title =
      List.filter ((==) "INAM" << .id) rawData
        |> List.map .value
        |> List.head
  in
    { album = Nothing
    , artist = artist
    , artists = []
    , genres = genres
    , title = title
    , disk = NumberData Nothing Nothing
    , track = NumberData Nothing Nothing
    , bpm = Nothing
    , duration = duration
    , path = path
    }
