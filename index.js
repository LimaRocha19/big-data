var express = require('express')
var app = express()
var http = require('http').Server(app)

var port = process.env.PORT || 5000

var uuid = require('uuid')

var mqtt = require('mqtt')

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
  , database: 'mongodb+srv://lima:st10900152@cluster0-6zng5.gcp.mongodb.net/test?retryWrites=true&w=majority' // must define it yet
}
mongoose.Promise = global.Promise
console.log('Initiating...')
console.log('Dabase:', config.database)
mongoose.connect(config.database, {
  useNewUrlParser: true
  , dbName: 'test'
}, function (error) {
  console.log(error)
}) // MongoDB cloud
app.set('secret', config.secret)

// mark - mqtt

var broker = require('./mqtt/broker')
let provider = 'mqtt://test.mosquitto.org'
broker.on('ready', function () {

  console.log('mosca working')

  // mark - client connection!

  var client = mqtt.connect(provider)
  console.log('mqtt client online')

  // mark - waiting for messages

  client.on('connect', function () {

    console.log('mqtt client connected and waiting for messages')

    client.subscribe('lima', function (error) {
      console.log(error)
    })
  })

  client.on('message', function (topic, message) {

    console.log(topic, message.toString())

    // mark - parsing message as JSON (only format accepted)

    try {
      let data = JSON.parse(message.toString())

      // mark - save in database

      var Log = require('./models/log')
      var log = new Log({
        watts: data.watts
        , phase: data.phase
        , created: new Date()
      })
      log.save(function (error) {
        if (!error) {
          console.log('test log created with some watts')
        } else {
          console.log(error.message)
        }
      })

    } catch (error) {
      console.log('parsing message failed, it is not in JSON format')
      console.log(message.toString())
    }

  })

})

// mark - welcome message (console and API)

let welcome = {
  port: port
  , message: 'Welcome to big-data project! Use the API docs to get access to my house energy consumption'
  , success: true
}

app.get('/', function (rec, res) {

  res.status(200).json(welcome)

})

app.post('/publish', function (req, res) {

  var data = req.body

  var client = mqtt.connect(provider)

  if (data.message) {
    client.publish('lima', data.message)
    res.status(200).json({
      success: true
      , message: 'Data published with success'
    })
  } else {
    res.status(500).json({
      success: false
      , message: 'No data sent to be published'
    })
  }

})

http.listen(port)

console.log(welcome)
