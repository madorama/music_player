module Main exposing (..)

import Html exposing (program)
import Response exposing (Response)
import Ports
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
    [ Ports.dropAudios DropAudios
    , Ports.audioUpdate UpdateTime
    ]


main : Program Never Model Msg
main =
  Html.program
    { init = init
    , view = view
    , update = update
    , subscriptions = subscriptions
    }
