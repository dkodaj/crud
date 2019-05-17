module Model exposing (..)

import Browser exposing (UrlRequest(..))
import Browser.Navigation exposing (Key)
import Http exposing (Error)
import String
import Url exposing (Url)


type alias Model =
    { activePage : Page
    , form : Form
    , key : Key
    , mobileNavOn : Bool --turns the navbar on and off on small screens
    , tableData : List Data
    }


type alias Data =
    { name : String
    , archEnemy : String
    , loveInterest : String
    }


type alias Form =
    Data


type FormField
    = Name
    | ArchEnemy
    | LoveInterest


type Msg
    = ClearForm
    | ChangeUrl Url
    | Download
    | IncomingData (Result Error (List Data))
    | IncomingServerMsg (Result Error String)
    | Input FormField String
    | Post (Cmd Msg)
    | RequestUrl UrlRequest
    | ToggleMobileNav


type Page
    = A
    | B
    | C
    | NotFound


emptyForm : Form
emptyForm =
    { name = ""
    , archEnemy = ""
    , loveInterest = ""
    }


toPath : Page -> String
toPath page =
    case page of
        A ->
            "a"

        B ->
            "b"

        C ->
            "c"

        NotFound ->
            "404"


updateForm : Form -> FormField -> String -> Data
updateForm currentForm field txt =
    case field of
        Name ->
            { currentForm | name = txt }

        ArchEnemy ->
            { currentForm | archEnemy = txt }

        LoveInterest ->
            { currentForm | loveInterest = txt }
