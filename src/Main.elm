module Main exposing (Model, Msg(..), init, main, subscriptions, update, view)

import Browser
import Html exposing (..)
import Html.Attributes as Attrs exposing (..)
import Html.Events exposing (..)
import Table exposing (defaultCustomizations)



-- MAIN


main =
    Browser.element
        { init = init
        , update = update
        , subscriptions = subscriptions
        , view = view
        }



-- MODEL


type alias Car =
    { regNr : String
    , car : String
    , workType : String
    , status : String
    }


type alias Model =
    { cars : List Car
    , tableState : Table.State
    }


init : () -> ( Model, Cmd Msg )
init _ =
    let
        model =
            { cars =
                [ { regNr = "ZT47121"
                  , car = "Hyundai I40"
                  , workType = "EU-kontroll"
                  , status = "Venter på mekaniker"
                  }
                , { regNr = "ZT52590"
                  , car = "Skoda Octavia"
                  , workType = "Dekkskifte"
                  , status = "Arbeid startet 08:14"
                  }
                ]
            , tableState = Table.initialSort "regNr"
            }
    in
    ( model
    , Cmd.none
    )



-- UPDATE


type Msg
    = SetTableState Table.State


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        SetTableState newState ->
            ( { model | tableState = newState }
            , Cmd.none
            )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- VIEW


view : Model -> Html Msg
view model =
    div []
        [ headerView
        , carsView model
        ]


headerView : Html Msg
headerView =
    div [ Attrs.class "header" ]
        [ img [ Attrs.src "assets/ams-logo.png" ] []
        , h1 [] [ text "Oppdatering fra vårt verksted" ]
        ]


tableConfig : Table.Config Car Msg
tableConfig =
    Table.customConfig
        { toId = .regNr
        , toMsg = SetTableState
        , columns =
            [ Table.stringColumn "Reg.nr" .regNr
            , Table.stringColumn "Bilmerke" .car
            , Table.stringColumn "Hva gjøres" .workType
            , Table.stringColumn "Status" .status
            ]
        , customizations = { defaultCustomizations | tableAttrs = [ class "overview" ] }
        }


carsView : Model -> Html Msg
carsView model =
    div [] [ Table.view tableConfig model.tableState model.cars ]
