process.env.NODE_ENV = process.env.NODE_ENV || 'development'

const eslint = require('./loaders/eslint')
const environment = require('./environment')

environment.loaders.prepend('eslint', eslint)
module.exports = environment.toWebpackConfig()
