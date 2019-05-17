module UI exposing (..)

import Char
import Html exposing (Html, a, br, div, img, input, label, nav, node, p, section, span, table, tbody, td, text, th, thead, tr)
import Html.Attributes exposing (class, height, href, src, style, type_, value)
import Html.Events exposing (onClick, onInput)
import List exposing (map)
import Model exposing (..)
import Request exposing (create, delete, read, updateDB)
import String

{-
   Class names come from the Bulma CSS framework.
   The stylesheet is imported in index.html.
   Docs:
       https://bulma.io/documentation/
-}


align here children =
    div
        [ class ("has-text-" ++ here) ]
        children


apiButtons : Model -> Html Msg
apiButtons model =
    let
        button clss txt msg =
            p
                [ class "control " ]
                [ Html.label
                    [ class clss, onClick msg ]
                    [ text txt ]
                ]
    in
    div
        [ class "field is-grouped has-text-centered" ]
        [ button "button is-success is-outlined" "Create" (Post (create model.form))
        , button "button is-info is-outlined" "Read" (Post (read model.form))
        , button "button is-warning is-outlined" "Update" (Post (updateDB model.form))
        , button "button is-danger is-outlined" "Delete" (Post (delete model.form))
        ]


break : Html Msg
break =
    br [] []


clearButton =
    Html.label
        [ class "button is-small is-warning", onClick ClearForm ]
        [ text "Clear form" ]


contentSimple : List (Html Msg) -> Html Msg
contentSimple xs =
    section [ class "section" ]
        [ div
            [ class "columns" ]
            [ div
                [ class "column is-2" ]
                []
            , div
                [ class "column is-6" ]
                xs
            , div
                [ class "column" ]
                []
            ]
        ]


contentComplex : List (Html Msg) -> List (Html Msg) -> Html Msg
contentComplex left right =
    let
        margin =
            style "margin" "0 20px 0"
    in
    div
        [ class "columns" ]
        [ div
            [ class "column is-4", margin ]
            left
        , div
            [ class "column is-4", margin ]
            right
        , div
            [ class "column" ]
            []
        ]


dataTable : List Data -> Html Msg
dataTable dataList =
    let
        toCell txt =
            td [] [ text txt ]

        toHead txt =
            th [] [ text txt ]

        toHeadRow txts =
            tr [] (map toHead txts)

        toRow data =
            tr [] (map toCell [ data.name, data.archEnemy, data.loveInterest ])
    in
    table
        [ class "table" ]
        [ thead [] [ toHeadRow [ "Hero", "Arch Enemy", "Love Interest" ] ]
        , tbody [] (map toRow dataList)
        ]


downloadButton : Html Msg
downloadButton =
    Html.label
        [ class "button is-success", onClick Download ]
        [ text ("Download" ++ nbsp ++ nbsp ++ nbsp)
        , span
            [ class "icon" ]
            [ node "i" [ class "fas fa-download" ] [] ]
        ]


form : Data -> Html Msg
form data =
    div
        []
        [ field "Hero" data.name (Input Name)
        , field "Arch Enemy" data.archEnemy (Input ArchEnemy)
        , field "Love Interest" data.loveInterest (Input LoveInterest)
        ]


field : String -> String -> (String -> Msg) -> Html Msg
field labelTxt inputTxt msg =
    div
        [ class "field is-horizontal" ]
        [ div
            [ class "field-label" ]
            [ label [ class "label" ] [ text labelTxt ] ]
        , div
            [ class "field-body" ]
            [ div
                [ class "field" ]
                [ p
                    [ class "control" ]
                    [ textInput inputTxt msg ]
                ]
            ]
        ]


level : Html Msg -> Html Msg
level child =
    nav
        [ class "level" ]
        [ div [ class "level-item" ] [ child ] ]


lorem : String
lorem =
    "Lorem ipsum dolor sit amet, consectetur adipisicing elit. Sed beatae reiciendis dolor fugiat magni, nemo ab iste, nulla commodi, tempore quia natus expedita voluptatibus ullam explicabo. Fugiat perspiciatis asperiores libero tempora, soluta voluptatem eaque praesentium, ratione dignissimos aspernatur maiores accusamus."


navBar : Model -> Html Msg
navBar model =
    let
        menuStyle =
            case model.mobileNavOn of
                True ->
                    "navbar-menu is-active"

                False ->
                    "navbar-menu"
    in
    nav
        [ class "navbar is-warning" ]
        [ navBarBrand model
        , div
            [ class menuStyle ]
            [ div
                [ class "navbar-start" ]
                (map (navBarItem model) [ A, B, C ])
            ]
        ]


navBarBrand : Model -> Html Msg
navBarBrand model =
    let
        spans =
            List.repeat 3 <| span [] []

        burgerClass =
            case model.mobileNavOn of
                True ->
                    "navbar-burger burger is-active"

                False ->
                    "navbar-burger burger"
    in
    div [ class "navbar-brand" ]
        [ a
            [ class "navbar-item", href "https://guide.elm-lang.org/" ]
            [ img [ src "assets/elmlogo.png", height 28 ] [] ]
        , div
            [ class burgerClass, onClick ToggleMobileNav ]
            spans
        ]

navBarItem : Model -> Page -> Html Msg
navBarItem model pageID =
    let
        itemClass =
            case model.activePage == pageID of
                True ->
                    "navbar-item is-active"

                False ->
                    "navbar-item"

        path =
            toPath pageID
    in
    a
        [ class itemClass, href ("/" ++ path) ]
        [ text <| "Menu_" ++ path ]



--non-breaking space
nbsp : String
nbsp =
    String.fromChar <| Char.fromCode 160 --decimal Unicode


page : Model -> Html Msg
page model =
    case model.activePage of
        A ->
            contentComplex
                --left
                [ break
                , break
                , align "right" [ clearButton ]
                , break
                , form model.form
                , break
                , level (apiButtons model)
                , align "centered " [ text "Empty fields act as wildcards in Read and Delete requests. Update is performed on rows that match Hero." ]
                ]
                --right
                [ break
                , break
                , level (dataTable model.tableData)
                , break
                , level downloadButton
                ]

        B ->
            contentSimple
                [ break
                , title "B"
                , align "left" [ text lorem ]
                ]

        C ->
            contentSimple
                [ break
                , title "C"
                , align "left" [ text lorem ]
                ]

        NotFound ->
            contentSimple
                [ break
                , title "404"
                , align "left" [ text "Not found" ]
                ]


textInput : String -> (String -> Msg) -> Html Msg
textInput txt msg =
    input
        [ class "input", type_ "text", value txt, onInput msg ]
        []


title : String -> Html Msg
title txt =
    node "h1" [ class "title" ] [ text txt ]
