PACKAGE = morpher_ru

all: clean test build

build: 
	coffee -c ./src/*.coffee
	$(wildcard  lib/*.js)
	
test:
	coffee -c ./test/*.coffee
	nodeunit ./test/test.js

clean:
	rm ./test/*.js
	rm ./src/*.js

.PHONY: test build all
