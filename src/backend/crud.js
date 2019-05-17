
const bodyParser = require('body-parser')
const express = require('express')
const path = require('path')

app = express()
app.use(bodyParser.json())

// file server
app.use(express.static(path.resolve('src/frontend')));

//serve Elm app
app.get("/", (req,res) => {
    res.sendFile(path.resolve('src/frontend/index.html'));
});
// Note that navigating to "localhost:3000/b" returns a "Cannot GET /b" error.
// But navigating to Menu_B within the app takes you to that address.
// This is because routing stays within the app entirely.
// To avoid the server error, one should tell it to serve "index.html"
// for all non-root requests as well. The Elm app then figures out what to show.

var db = require('./fakedb.js')

//api
app.post("/create", function (req, res) {
    res.json(db.create(req.body))
});

app.post("/read", function (req, res) {
    res.json(db.read(req.body));
});

app.post("/update", function (req, res) {
    res.json(db.update(req.body))
});

app.post("/delete", function (req, res) {
    res.json(db.del(req.body))
});

// start server
app.listen(3000);
console.log('Running on localhost:3000')