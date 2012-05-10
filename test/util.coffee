util = require '../lib/util'

describe 'util', ->
    describe 'THID', ->
        thidFoobar = new util.THID '8843d7f92416211de9ebb963ff4ce28125932878'

        it 'generates a random THID', ->
            thid = new util.THID
            thid.toString().length.should.equal 40
            thid.length.should.equal 20
            thid.should.not.equal thidFoobar

        it 'hashes content', ->
            thid = util.THID.fromHash 'foobar'
            thid.should.equal '8843d7f92416211de9ebb963ff4ce28125932878'
            thid.should.equal thidFoobar
