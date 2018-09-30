import Browser
import Html exposing (..)

main =
  Browser.sandbox { init = 0, update = update, view = view }

update msg model =
  model

view model =
  Html.div [] [text "Hello"]