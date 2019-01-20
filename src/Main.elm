import Browser exposing (Document)
import Browser.Navigation as Nav
import Url exposing (Url)

import App


type alias Model = App.Model
type Msg
    = AppMsg App.Msg
    | NoMsg


main : Program () Model Msg
main =
    Browser.application {
        init = init,
        update = update,
        subscriptions = subscriptions,
        onUrlRequest = (\a -> NoMsg),
        onUrlChange = (\a -> NoMsg),
        view = view
    }


init : () -> Url -> Nav.Key -> ( Model, Cmd Msg )
init flags url navk = ( initModel, initCmd )


initModel : Model
initModel = App.initModel


initCmd : Cmd Msg
initCmd = Cmd.map AppMsg App.initCmd


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model = ( updateModel msg model, updateCmd msg model )


updateModel : Msg -> Model -> Model
updateModel msg model =
    case msg of
        AppMsg appMsg -> App.updateModel appMsg model
        NoMsg -> model


updateCmd : Msg -> Model -> Cmd Msg
updateCmd msg model = Cmd.none


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.map AppMsg (App.subscriptions model)


view : Model -> Document Msg
view model = { title = "App", body = [ App.view model ] }
