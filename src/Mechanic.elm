module Mechanic exposing (Model, Msg(..), init, main, subscriptions, update, view)

import Browser
import Form exposing (Form)
import Form.Input as Input
import Form.Validate as Validate exposing (..)
import Html exposing (..)
import Html.Attributes as Attrs exposing (..)
import Html.Events as Events exposing (..)
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
    , mechanic : String
    }


type Page
    = Overview
    | CreateCar


type alias Model =
    { cars : List Car
    , mechanic : String
    , tableState : Table.State
    , page : Page
    , carForm : Form () Car
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
                  , mechanic = "Ole"
                  }
                , { regNr = "ZT52590"
                  , car = "Skoda Octavia"
                  , workType = "Dekkskifte"
                  , status = "Arbeid startet 08:14"
                  , mechanic = "Ole"
                  }
                ]
            , mechanic = "Ole"
            , tableState = Table.initialSort "regNr"
            , page = Overview
            , carForm = Form.initial [] validate
            }
    in
    ( model
    , Cmd.none
    )


validate : Validation () Car
validate =
    succeed Car
        |> andMap (field "regNr" string)
        |> andMap (field "car" string)
        |> andMap (field "workType" string)
        |> andMap (field "status" string)
        |> andMap (field "mechanic" string)



-- UPDATE


type Msg
    = SetTableState Table.State
    | ChangePage Page
    | FormMsg Form.Msg


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        SetTableState newState ->
            ( { model | tableState = newState }
            , Cmd.none
            )

        ChangePage page ->
            ( { model | page = page }
            , Cmd.none
            )

        FormMsg formMsg ->
            ( { model | carForm = Form.update validate formMsg model.carForm }, Cmd.none )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- VIEW


view : Model -> Html Msg
view model =
    let
        page =
            case model.page of
                Overview ->
                    [ headerView model, carsView model, createCarButton model ]

                CreateCar ->
                    [ headerView model, createCarView model ]
    in
    div [] page


headerView : Model -> Html Msg
headerView model =
    div [ Attrs.class "header" ]
        [ img [ Attrs.src "assets/ams-logo.png", Events.onClick (ChangePage Overview) ] []
        ]


createCarView : Model -> Html Msg
createCarView model =
    div [] [ h1 [] [ text "Ny bil" ], Html.map FormMsg (formView model.carForm) ]


createCarButton : Model -> Html Msg
createCarButton model =
    button [ class "create-car", Events.onClick (ChangePage CreateCar) ] [ text "Ny bil" ]


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
        , customizations = { defaultCustomizations | tableAttrs = [ class "overview mechanic" ] }
        }


carsView : Model -> Html Msg
carsView model =
    div []
        [ h1 [] [ text ("Dine biler: " ++ model.mechanic) ]
        , Table.view tableConfig model.tableState model.cars
        ]


formView : Form () Car -> Html Form.Msg
formView form =
    let
        -- error presenter
        errorFor field =
            case field.liveError of
                Just error ->
                    -- replace toString with your own translations
                    div [ class "error" ] [ text (Debug.toString error) ]

                Nothing ->
                    text ""

        -- fields states
        regNr =
            Form.getFieldAsString "regNr" form

        car =
            Form.getFieldAsString "car" form

        workType =
            Form.getFieldAsString "workType" form

        status =
            Form.getFieldAsString "status" form

        mechanic =
            Form.getFieldAsString "mechanic" form
    in
    div []
        [ label [] [ text "Reg.nr" ]
        , Input.textInput regNr []
        , errorFor regNr
        , label [] [ text "Bilmerke" ]
        , Input.textInput car []
        , errorFor car
        , label [] [ text "Hva gjøres" ]
        , Input.textInput workType []
        , errorFor workType
        , label [] [ text "Status" ]
        , Input.textInput status []
        , errorFor status
        , label [] [ text "Mekaniker" ]
        , Input.textInput mechanic []
        , errorFor mechanic
        , button
            [ onClick Form.Submit ]
            [ text "Lagre" ]
        ]
