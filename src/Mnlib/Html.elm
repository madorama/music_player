module Mnlib.Html exposing (..)

import Html exposing (..)
import Html.Attributes as Attr exposing (..)


prop : String -> String -> Attribute msg
prop name value =
  style [(name, value)]


empty : Html msg
empty =
  text ""


flexbox : String -> List (Attribute msg) -> List (Html msg) -> Html msg
flexbox dir attrs childs =
  div
    ( prop "display" "flex"
        :: prop "flex-direction" dir
        :: prop "box-sizing" "border-box"
        :: attrs
    )
    childs


column : List (Attribute msg) -> List (Html msg) -> Html msg
column =
  flexbox "column"


columnReverse : List (Attribute msg) -> List (Html msg) -> Html msg
columnReverse =
  flexbox "column-reverse"


row : List (Attribute msg) -> List (Html msg) -> Html msg
row =
  flexbox "row"


rowReverse : List (Attribute msg) -> List (Html msg) -> Html msg
rowReverse =
  flexbox "row-reverse"


fillBox : List (Attribute msg) -> List (Html msg) -> Html msg
fillBox attrs =
  column
    ( [ prop "width" "100%"
      , prop "height" "100%"
      , prop "display" "flex"
      , prop "position" "absolute"
      , prop "left" "0"
      , prop "top" "0"
      , prop "user-select" "none"
      ]
        ++ attrs
    )
