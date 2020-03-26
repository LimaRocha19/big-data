var express = require('express')
var app = express()
var http = require('http').Server(app)

var port = process.env.PORT || 5000

var uuid = require('uuid')

// mark - body-parser

var body_parser = require('body-parser')
app.use(body_parser.urlencoded({
  extended: false
}))
app.use(body_parser.json())

// mark - mongodb database

var mongoose = require('mongoose')
var config = {
  secret: '639dded6-ba18-4647-83d6-9b0c7cf75c2d' // random uuid
  , database: 'mongodb://somewhere_over_the_rainbow' // must define it yet
}
mongoose.Promise = global.Promise
console.log('Initiating...')
console.log('Dabase:', config.database)
// mongoose.connect(config.database) // must define database yet
app.set('secret', config.secret)

// mark - welcome message (console and API)

let welcome = {
  port: port
  , message: 'Welcome to big-data project! Use the API docs to get access to my house energy consumption'
  , success: true
}

app.get('/', function (rec, res) {

  res.status(200).json(welcome)

})

http.listen(port)

console.log(welcome)
