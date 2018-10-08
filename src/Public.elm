module Public exposing (Model, Msg(..), init, main, subscriptions, update, view)

import Browser
import Html exposing (..)
import Html.Attributes as Attrs exposing (..)
import Html.Events exposing (..)
import Models exposing (Car, Mechanic, initialCars, initialMechanics)
import Table exposing (Column, defaultCustomizations)
import Task
import Time



-- MAIN


main =
    Browser.element
        { init = init
        , update = update
        , subscriptions = subscriptions
        , view = view
        }



-- MODEL


type alias Model =
    { cars : List Car
    , mechanics : List Mechanic
    , time : Time.Posix
    , zone : Time.Zone
    , tableState : Table.State
    }


init : () -> ( Model, Cmd Msg )
init _ =
    let
        model =
            { cars = initialCars
            , mechanics = initialMechanics
            , zone = Time.utc
            , time = Time.millisToPosix 0
            , tableState = Table.initialSort "regNr"
            }
    in
    ( model
    , Cmd.none
    )



-- UPDATE


type Msg
    = SetTableState Table.State
    | Tick Time.Posix
    | AdjustTimeZone Time.Zone


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        SetTableState newState ->
            ( { model | tableState = newState }
            , Cmd.none
            )

        Tick newTime ->
            ( { model | time = newTime }
            , Cmd.none
            )

        AdjustTimeZone newZone ->
            ( { model | zone = newZone }
            , Cmd.none
            )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Time.every 1000 Tick



-- VIEW


view : Model -> Html Msg
view model =
    div []
        [ headerView model
        , carsView model
        ]


headerView : Model -> Html Msg
headerView model =
    div [ Attrs.class "header" ]
        [ img [ Attrs.src "assets/ams-logo.png" ] []
        , h1 [ Attrs.class "clock" ] [ text (timeView model) ]
        , h1 [ Attrs.class "title" ] [ text "Oppdatering fra vårt verksted" ]
        ]


leadingZero : Int -> String
leadingZero number =
    if number >= 0 && number <= 9 then
        "0" ++ String.fromInt number

    else
        String.fromInt number


timeView : Model -> String
timeView { time, zone } =
    leadingZero (Time.toHour zone time)
        ++ ":"
        ++ leadingZero (Time.toMinute zone time)
        ++ ":"
        ++ leadingZero (Time.toSecond zone time)


tableConfig : Table.Config Car Msg
tableConfig =
    Table.customConfig
        { toId = .regNr
        , toMsg = SetTableState
        , columns =
            [ Table.stringColumn "Reg.nr" .regNr
            , Table.stringColumn "Bilmerke" .car
            , Table.stringColumn "Hva gjøres" .workType
            , Table.customColumn
                { name = "Mekaniker"
                , viewData = \car -> showMechanicFromCar car
                , sorter = Table.unsortable
                }
            , Table.stringColumn "Status" .status
            ]
        , customizations = { defaultCustomizations | tableAttrs = [ class "overview" ] }
        }


showMechanicFromCar : Car -> String
showMechanicFromCar car =
    String.fromInt car.mechanicId


carsView : Model -> Html Msg
carsView model =
    div [] [ Table.view tableConfig model.tableState model.cars ]
