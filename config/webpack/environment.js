const { environment } = require('@rails/webpacker')
const webpack = require('webpack')
const vue =  require('./loaders/vue')
const dotenv = require('dotenv')

dotenv.config({ path: '.env', silent: true })

environment.plugins.prepend('Environment', new webpack.EnvironmentPlugin(JSON.parse(JSON.stringify(process.env))))
environment.loaders.append('vue', vue)

module.exports = environment
