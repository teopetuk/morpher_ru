###
    simple interface to morpher.ru service
###

async = require 'async'
ejs = require 'ejs'
path = require 'path'
jsonPath = require 'JSONPath'
querystring = require 'querystring'
http = require 'http'
{parseString} = require 'xml2js'

urlMorpher = "http://morpher.ru/WebService.asmx/GetXml?s="
casePaths = [
    "$['Р'][0]"
    "$['Д'][0]"
    "$['В'][0]"
    "$['Т'][0]"
    "$['П'][0]"
    "$['множественное'][0]['И'][0]"
    "$['множественное'][0]['Р'][0]"
    "$['множественное'][0]['Д'][0]"
    "$['множественное'][0]['В'][0]"
    "$['множественное'][0]['Т'][0]"
    "$['множественное'][0]['П'][0]"
]

module.exports =

    ###
        returns array of cases
    ###
    word: (word, callback)->
              [morphedXML,rq,morphed,data] = ['', null, null, null]
              async.series  steps =
                               "http": (callback)->
                                           rq = http.get urlMorpher + word,
                                                         (res)->
                                                             res.setEncoding('utf8');
#                                                             console.log "Got response: " + res.statusCode
                                                             res.on 'data',
                                                                    (data)->
#                                                                        console.log data.toString()
                                                                        morphedXML += data.toString()

                                                             res.on 'end',
                                                                    ->
                                                                        callback()

                                           rq.on 'error', (e) -> callback e

                               "xml2js": (callback)->
                                             rq.end()
                                             parseString morphedXML,
                                                         (e, r)->
                                                             morphed = r
                                                             callback e
                               "parse": (callback)->
                                            morphed = morphed.xml
                                            data =
                                                for casePath in casePaths
                                                    caseValues = jsonPath.eval morphed, casePath
                                                    caseValues[0]
                                            data.splice 0, 0, word
                                            callback()
                            ,(error, result)->
                                 callback error, data


    ###
    returns something like:
        "word":["word_case1","word_case2",...]
        ...
    ###
    words: (words, callback)->
               self = @
               morphed = {}
               async.forEachSeries words
                                   , (word, callback)->
                                         console.log "word:", word
                                         self.word word,
                                                   (error, result)->
                                                       morphed[word] = result
                                                       callback error

                                   , (error, result)->
                                         callback error, morphed

