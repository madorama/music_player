module View.Player exposing (..)

import Html exposing (..)
import Html.Attributes as Attr exposing (..)
import Html.Events as Ev exposing (..)
import Mnlib.Html exposing (..)
import Model exposing (Model)
import Msg exposing (Msg)

view : Model -> Html Msg
view model =
  row
    []
    [ viewPlayButton model
    ]


viewPlayButton : Model -> Html Msg
viewPlayButton model =
  empty
