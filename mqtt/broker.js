var mosca = require('mosca')
var settings = {
  port: 1883
}

module.exports = new mosca.Server(settings)
