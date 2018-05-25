Ltc Wallet Client
======

[![NPM Package](https://img.shields.io/npm/v/ltc-wallet-client.svg?style=flat-square)](https://www.npmjs.org/package/ltc-wallet-client)
[![Build Status](https://img.shields.io/travis/owstack/ltc-wallet-client.svg?branch=master&style=flat-square)](https://travis-ci.org/owstack/ltc-wallet-client) 
[![Coverage Status](https://coveralls.io/repos/owstack/ltc-wallet-client/badge.svg)](https://coveralls.io/r/owstack/ltc-wallet-client)

The *official* client library for [ltc-wallet-service](https://github.com/owstack/ltc-wallet-service).

## Attribution

This repository was created by copy forking [bitcore-wallet-client commit d986bbb](https://github.com/bitpay/bitcore-wallet-client/commit/d986bbb69d01be56f1cfd09c89625f587de2bc02).

## Description

This package communicates with LTCWS [Ltc wallet service](https://github.com/owstack/ltc-wallet-service) using the REST API. All REST endpoints are wrapped as simple async methods. All relevant responses from LTCWS are checked independently by the peers, thus the importance of using this library when talking to a third party LTCWS instance.

## Get Started

You can start using ltc-wallet-client in any of these two ways:

* via [Bower](http://bower.io/): by running `bower install ltc-wallet-client` from your console
* or via [NPM](https://www.npmjs.com/package/ltc-wallet-client): by running `npm install ltc-wallet-client` from your console.

## Example

Start your own local [Ltc wallet service](https://github.com/owstack/ltc-wallet-service) instance. In this example we assume you have `ltc-wallet-service` running on your `localhost:3232`.

Then create two files `irene.js` and `tomas.js` with the content below:

**irene.js**

``` javascript
var Client = require('@owstack/ltc-wallet-client');


var fs = require('fs');
var LTCWS_INSTANCE_URL = 'https://ltcws.openwalletstack.com/ltcws/api'

var client = new Client({
  baseUrl: LTCWS_INSTANCE_URL,
  verbose: false,
});

client.createWallet("My Wallet", "Irene", 2, 2, {network: 'testnet'}, function(err, secret) {
  if (err) {
    console.log('error: ',err); 
    return
  };
  // Handle err
  console.log('Wallet Created. Share this secret with your copayers: ' + secret);
  fs.writeFileSync('irene.dat', client.export());
});
```

**tomas.js**

``` javascript

var Client = require('@owstack/ltc-wallet-client');


var fs = require('fs');
var LTCWS_INSTANCE_URL = 'https://ltcws.openwalletstack.com/ltcws/api'

var secret = process.argv[2];
if (!secret) {
  console.log('./tomas.js <Secret>')

  process.exit(0);
}

var client = new Client({
  baseUrl: LTCWS_INSTANCE_URL,
  verbose: false,
});

client.joinWallet(secret, "Tomas", {}, function(err, wallet) {
  if (err) {
    console.log('error: ', err);
    return
  };

  console.log('Joined ' + wallet.name + '!');
  fs.writeFileSync('tomas.dat', client.export());


  client.openWallet(function(err, ret) {
    if (err) {
      console.log('error: ', err);
      return
    };
    console.log('\n\n** Wallet Info', ret); //TODO

    console.log('\n\nCreating first address:', ret); //TODO
    if (ret.wallet.status == 'complete') {
      client.createAddress({}, function(err,addr){
        if (err) {
          console.log('error: ', err);
          return;
        };

        console.log('\nReturn:', addr)
      });
    }
  });
});
```

Install `ltc-wallet-client` before start:

```
npm i @owstack/ltc-wallet-client
```

Create a new wallet with the first script:

```
$ node irene.js
info Generating new keys 
 Wallet Created. Share this secret with your copayers: JbTDjtUkvWS4c3mgAtJf4zKyRGzdQzZacfx2S7gRqPLcbeAWaSDEnazFJF6mKbzBvY1ZRwZCbvT
```

Join to this wallet with generated secret:

```
$ node tomas.js JbTDjtUkvWS4c3mgAtJf4zKyRGzdQzZacfx2S7gRqPLcbeAWaSDEnazFJF6mKbzBvY1ZRwZCbvT
Joined My Wallet!

Wallet Info: [...]

Creating first address:

Return: [...]

```

Note that the scripts created two files named `irene.dat` and `tomas.dat`. With these files you can get status, generate addresses, create proposals, sign transactions, etc.


