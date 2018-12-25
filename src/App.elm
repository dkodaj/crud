module App exposing (main)

import Browser exposing (Document, UrlRequest(..), application, document)
import Browser.Navigation as Nav exposing (Key)
import Html exposing (Html, div)
import Modules.Model exposing (..)
import Modules.Ports exposing (download)
import Modules.Request exposing (fetchAllRows)
import Modules.Serialize exposing (toJson)
import Modules.UI exposing (navBar, page)
import Url exposing (Url)


main =
    application
        { init = init
        , subscriptions = always Sub.none
        , update = update
        , view = view
        , onUrlChange = ChangeUrl
        , onUrlRequest = RequestUrl
        }


init : () -> Url -> Key -> ( Model, Cmd Msg )
init _ url key =
    let
        initialModel =
            { activePage = route url
            , form = emptyForm
            , key = key
            , mobileNavOn = False -- controls the visibility of the menu bar on mobile devices
            , tableData = []
            }
    in
    ( initialModel, fetchAllRows )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ChangeUrl url ->
            ( { model | activePage = route url }, Cmd.none )

        ClearForm ->
            ( { model | form = emptyForm }, Cmd.none )

        Download ->
            ( model, download <| toJson model.tableData )

        IncomingData (Ok data) ->
            ( { model | tableData = data }, Cmd.none )

        IncomingData (Err _) ->
            ( { model | tableData = [] }, Cmd.none )

        IncomingServerMsg (Ok _) ->
            ( model, fetchAllRows )

        IncomingServerMsg (Err _) ->
            ( model, Cmd.none )

        Input field txt ->
            ( { model | form = updateForm model.form field txt }, Cmd.none )

        Post request ->
            ( model, request )

        RequestUrl urlRequest ->
            case urlRequest of
                Internal url ->
                    ( model
                    , Nav.pushUrl model.key (Url.toString url)
                    )

                External url ->
                    ( model
                    , Nav.load url
                    )

        ToggleMobileNav ->
            ( { model | mobileNavOn = not model.mobileNavOn }, Cmd.none )


route : Url -> Page
route url =
    case url.path of
        "/" ->
            A

        "/a" ->
            A

        "/b" ->
            B

        "/c" ->
            C

        _ ->
            NotFound


view : Model -> Document Msg
view model =
    { title = "CRUD"
    , body =
        [ navBar model
        , page model
        ]
    }
