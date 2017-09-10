module Main exposing (..)

import Html exposing (..)
import Response exposing (..)
import Ports
import File exposing (File)
import Model exposing (Model)
import Msg exposing (..)
import Update exposing (update)
import View exposing (view)


init : Response Model Msg
init =
  Model.init ! []


subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.batch
    [ Ports.dropAudios DropAudios ]


main =
  Html.program
    { init = init
    , view = view
    , update = update
    , subscriptions = subscriptions
    }
