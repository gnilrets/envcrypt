Envcrypt
=========

Envcrypt provides an easy way to securely encrypt and decrypt secrets
(passwords) that need to be stored for use in automated processes.

**Status:** Just have a README!  Working on the rest.

## Use

Encrypt a secret
````ruby
$ envcrypt -p mypassword

encrypted: xxx
key: xxx
````

Set the key as an environment variable (bash example)
````bash
export ENVCRYPT_KEY=xxx
````

Decrypt the password in Ruby code
````ruby
require 'envcrypt'

encrypted_pwd = "xxx"
decrypted_pwd = Envcrypt::decrypt(encrypted_pwd, key: ENV['ENVCRYPT_KEY'])
````

The second argument to decrypt is **optional**.  The default `key` is
`ENV['ENVCRYPT_KEY']`, but you have to option to set it explicitly if you want to
get it from somewhere else.

##### Optional

**Need to be able to set a mode so we can use this with Heroku's version of OpenSSL.
Not sure exactly how this will work**

##### Using existing keys to encrypt secrets

Secrets can also be encrypted using existing keys if you want to use
one key to encrypt multiple secrets.

````ruby
$ envcrypt -p mypassword -k xxx
````


## Use case

Suppose I've got a web API that only accepts plaintext passwords.  I
need to store that password in a database or in a file somewhere to
automate an interface with the web API.  If an attacker somehow gains
access to the database or file, I'm screwed if I store the password as
plaintext or use some simple obfuscation.  Envcrypt allows me to store
an encrypted version of the password and decrypt it only when needed.
The trick is to access the decryption key from an environment
variable.  These can be set from the command line before launching the
automated process, in a locked down .bashrc file, or as Heroku config
variables.

Of course, if an attacker was able to get a hold of *both* the password
and the decryption keys, you're screwed, but security is all about making
it difficult for attackers.
