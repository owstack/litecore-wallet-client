.PHONY: cover

BIN_PATH:=node_modules/.bin/

all:	ltc-wallet-client.min.js

clean:
	rm ltc-wallet-client.js
	rm ltc-wallet-client.min.js

ltc-wallet-client.js: index.js lib/*.js
	${BIN_PATH}browserify $< > $@

ltc-wallet-client.min.js: ltc-wallet-client.js
	uglify  -s $<  -o $@

cover:
	./node_modules/.bin/istanbul cover ./node_modules/.bin/_mocha -- --reporter spec test
