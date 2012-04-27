Pattern = require '../lib/pattern'

describe 'Pattern', ->
    
    describe '"hello"', ->
        pattern = Pattern.compile 'hello'
        
        it 'should compile to a StringPattern', ->
            pattern.constructor.name.should.equal "StringPattern"

        it 'should match "hello"', ->
            pattern.match("hello").should.equal(true)
            
        it 'should not match "hello::world"', ->
            pattern.match("hello::world").should.equal(false)
            
        it 'should not match "say::hello"', ->
            pattern.match("say::hello").should.equal(false)
            
    describe '"hello::*"', ->
        pattern = Pattern.compile 'hello::*'
        
        it 'should compile to a PrefixPattern', ->
            pattern.constructor.name.should.equal "PrefixPattern"

        it 'should match "hello::"', ->
            pattern.match("hello::").should.equal(true)
            
        it 'should match "hello::world"', ->
            pattern.match("hello::world").should.equal(true)
            
        it 'should not match "say::hello::world"', ->
            pattern.match("say::hello::world").should.equal(false)
            
    describe '"say::*::world"', ->
        pattern = Pattern.compile 'say::*::world'

        it 'should compile to /^say::.*::world$/', ->
            pattern.pattern.source.should.equal '^say::.*::world$'
        
        it 'should compile to a RegexpPattern', ->
            pattern.constructor.name.should.equal "RegexpPattern"

        it 'should match "say::hello::world"', ->
            pattern.match("say::hello::world").should.equal(true)
            
        it 'should match "say::goodbye::world"', ->
            pattern.match("say::goodbye::world").should.equal(true)
            
        it 'should not match "say::hello::world::now"', ->
            pattern.match("say::hello::world::now").should.equal(false)
            
    describe '/hel*o/', ->
        pattern = Pattern.compile /hel*o/
        
        it 'should compile to a StringPatter', ->
            pattern.constructor.name.should.equal "RegexpPattern"

        it 'should match "hello"', ->
            pattern.match("hello").should.equal(true)
            
        it 'should match "hello::world"', ->
            pattern.match("hello::world").should.equal(true)
            
        it 'should match "say::hello"', ->
            pattern.match("say::hello").should.equal(true)
            
        it 'should match "hellllllllo"', ->
            pattern.match("hellllllllo").should.equal(true)
            
        it 'should not match "hellllooo"', ->
            pattern.match("hellllooo").should.equal(true)
            
