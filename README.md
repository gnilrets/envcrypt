Envcrypt
=========

Envcrypt provides an easy way to securely encrypt and decrypt secrets
(passwords) that need to be stored for use in automated processes.

## Install
````bash
gem install envcrypt
````

## Use

Encrypt a secret via

````
$ envcrypt -s Orange
Encrypted Secret: zTbH59gpFIIuXGYRuK9pHQ==
ENVCRYPT_KEY='eWa7QqyF6eE/bEthGO4BgA==$9OZzJ6xIgEcovfEOHIhVb9Gaw5/FeSgDmTErws1+API=$ccRiLqJjyL6MypWHOGfpcQ=='
WARNING: It is critical that the key and encryption password be stored separately!
````

Set the key as an environment variable (bash example)

````
$ export ENVCRYPT_KEY='eWa7QqyF6eE/bEthGO4BgA==$9OZzJ6xIgEcovfEOHIhVb9Gaw5/FeSgDmTErws1+API=$ccRiLqJjyL6MypWHOGfpcQ=='
````

Go ahead and test decryption from the command line
````
$ envcrypt -d 'zTbH59gpFIIuXGYRuK9pHQ=='
Decrypted: Orange
````


Decrypt the password in Ruby code

````ruby
require 'envcrypt'

encrypted_pwd = "zTbH59gpFIIuXGYRuK9pHQ=="
crypt = Envcrypter.new(key: ENV['ENVCRYPT_KEY']) #key is optional (default: ENV['ENVCRYPT_KEY'])
decrypted_pwd = crypt.decrypt(encrypted_pwd)
````

##### Using existing keys to encrypt secrets

By default a new encryption key is created for each use command line
`envcrypt` tool.  Secrets can also be encrypted using existing keys if
you want to use one key to encrypt multiple secrets.

````
$ envcrypt -p Orange -k $ENVCRYPT_KEY
````


## Use case

Suppose I've got a web API that only accepts plaintext passwords.  I
need to store that password in a database or in a file somewhere to
automate an interface with the web API.  If an attacker somehow gains
access to the database or file, I'm screwed if I store the password as
plaintext or use some simple obfuscation.  Envcrypt allows me to store
an encrypted version of the password and decrypt it only when needed.
The trick is to store the decryption key in an environment variable.
These can be set from the command line before launching the automated
process, in a locked down .bashrc file, or as Heroku config variables.

Of course, if an attacker was able to get a hold of *both* the password
and the decryption keys, you're screwed, but security is all about making
it difficult for attackers.
