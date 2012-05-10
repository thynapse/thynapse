crypto = require 'crypto'

module.exports = util = {}

class THID extends Buffer
    constructor: (bytes, encoding='hex') ->
        super 20
        if arguments.length
            if typeof bytes == 'string'
                @write bytes, 0, 20, encoding
            else
                throw "Invalid arguments to THID"
        else
            crypto.randomBytes(20).copy this

    toString: (encoding='hex') ->
        super encoding

    valueOf: -> @toString()

THID.fromHash = (contents) ->
    hash = crypto.createHash 'sha1'
    hash.update contents
    new THID(hash.digest('binary'), 'binary')

util.THID = THID
