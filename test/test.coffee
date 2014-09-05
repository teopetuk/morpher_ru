module.exports =
    setUp: (callback) ->
                        callback()
    tearDown: (callback) ->
                        callback()

    "morpher":
            "rq": (t)->
                      m = require '../src/morpher'
                      m.word    'простое слово',
                                (e,r)->
                                    console.log JSON.stringify {e,r}
                                    t.ok r.length==12
                                    t.done()
            "rq2": (t)->
                      m = require '../src/morpher'
                      m.word    'бразильское кератиновое выпрямление волос',
                                (e,r)->
                                    console.log JSON.stringify {e,r}
                                    t.ok r.length==12
                                    t.done()
            "rq3": (t)->
                      m = require '../src/morpher'
                      m.word    'изготовление и монтаж металлоконструкций',
                                (e,r)->
                                    console.log JSON.stringify {e,r}
                                    t.ok r.length==12
                                    t.done()

