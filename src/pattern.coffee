# Abstract Pattern takes an arbitrary function
class Pattern
    constructor: (@pattern) ->

    match: (text) ->
        !!@pattern(text)

Pattern.compile = (pattern) ->
    switch typeof pattern
        when 'function'
            new Pattern pattern
        when 'object'
            if pattern instanceof RegExp
                new RegexpPattern pattern
            else
                false
        else
            string = '' + pattern
            if string.length - 1 == string.indexOf '*'
                new PrefixPattern string.slice 0, string.length - 1
            else if -1 < string.indexOf '*'
                RegexpPattern.fromString pattern
            else
                new StringPattern string

class StringPattern extends Pattern
    compile: (@pattern) ->

    match: (text) ->
        text == @pattern

class RegexpPattern extends Pattern
    constructor: (@pattern) ->
        console.log @pattern
        @pattern = new RegExp @pattern unless @pattern instanceof RegExp

    match: (text) ->
        !!@pattern.exec text

RegexpPattern.fromString = (string) ->
    new RegexpPattern Pattern.stringToRegexp(string)

Pattern.stringToRegexp = (string) ->
    string = string.replace /[-[\]{}()*+?.,\\^$|#\s]/g, "\\$&"
    string = string.replace "\\*", '.*'
    string = string.replace "\\?", '.'
    "^" + string + "$"


class PrefixPattern extends Pattern
    isPrefix: true
    
    match: (text) ->
        0 == text.indexOf @pattern

module.exports = Pattern

