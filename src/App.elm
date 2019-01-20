module App exposing (Model, Msg, initModel, initCmd, updateModel, subscriptions, view)

import Html exposing (Html, div, text)
import Html.Attributes exposing (attribute)
import Task
import Time


type alias Model = {
        time : Time.Posix,
        zone : Time.Zone,
        zname : String
    }


type Msg
    = GotTime Time.Posix
    | GotZone Time.Zone
    | GotZoneName Time.ZoneName


initModel : Model
initModel = {
        time = Time.millisToPosix 0,
        zone = Time.utc,
        zname = "UTC"
    }


initCmd : Cmd Msg
initCmd = startClock


startClock : Cmd Msg
startClock =
    Cmd.batch [
        Task.perform GotTime Time.now,
        Task.perform GotZone Time.here,
        Task.perform GotZoneName Time.getZoneName
    ]


updateModel : Msg -> Model -> Model
updateModel msg model =
    case msg of
        GotTime time -> { model | time = time }
        GotZone zone -> { model | zone = zone }
        GotZoneName zname ->
            case zname of
                Time.Name name -> { model | zname = name }
                Time.Offset num -> { model | zname = String.fromInt num }


subscriptions : Model -> Sub Msg
subscriptions model =
    Time.every 1 GotTime


view : Model -> Html msg
view model =
    let
        hh = String.padLeft 2 '0' (String.fromInt (Time.toHour model.zone model.time))
        mm = String.padLeft 2 '0' (String.fromInt (Time.toMinute model.zone model.time))
        ss = String.padLeft 2 '0' (String.fromInt (Time.toSecond model.zone model.time))
        ms = String.padLeft 3 '0' (String.fromInt (Time.toMillis model.zone model.time))
    in
    div [ attribute "style" "font-family: monospace" ] [
        text (hh ++ ":" ++ mm ++ ":" ++ ss ++ "." ++ ms ++ " "),
        text model.zname  -- another text node keeps it from updating with the clock
    ]
