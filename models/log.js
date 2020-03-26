// information about electricity consumption

var mongoose = require('mongoose')
var Schema = mongoose.Schema

var log_schema = new Schema({
  watts: Number
  , phase: String
  , created: Date
})

module.exports = mongoose.model('log', log_schema)
