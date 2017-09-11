module Mnlib.Update exposing (..)


andThen : (model -> (model, Cmd msg)) -> (model, Cmd msg) -> (model, Cmd msg)
andThen function ( model, cmd ) =
  let
    ( newModel, newCmd ) =
      function model
  in
    newModel ! [ cmd, newCmd ]


addCmd : Cmd msg -> (model, Cmd msg) -> (model, Cmd msg)
addCmd newCmd ( model, cmd ) =
  model ! [ cmd, newCmd ]


updateModel : (model -> model) -> (model, Cmd msg) -> (model, Cmd msg)
updateModel function ( model, cmd ) =
  ( function model, cmd )
