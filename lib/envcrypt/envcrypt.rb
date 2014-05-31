# Public: Envcrypt module contains all of the methods/classes to
# perform encryption and decryption of passwords
#
# Examples
#
#   mypassword = "secret"
#   crypt = Envcrypter.new
#   encrypted_pwd = crypt.encrypt(mypassword)
#   decrypted_pwd = crypt.decrypt(encrypted_pwd)
module Envcrypt
  class Envcrypter

    # Public: Returns the key used to encrypt/decrypt secrets
    attr_reader :key

    # Public: Initialize an Envcrypter object
    #
    # key - A string representing the key to be used for encryption
    #       and decryption (default: ENV['ENVCRYPT_KEY'])
    def initialize(key: ENV['ENVCRYPT_KEY'])
      @key = key == nil ? generate_key : key
      @de_cipher = nil
      @en_cipher = nil
    end

    # Public: Generates a random key
    #
    # Returns the key
    def generate_key
      @key = "#{SecureRandom.base64}$#{SecureRandom.base64(32)}$#{SecureRandom.base64}"
    end


    # Public: Encrypts a secret
    #
    # secret - the secret string to be encrypted
    #
    # Returns the encrypted string
    def encrypt(secret)
      cipher = create_cipher(:encrypt)

      encrypted = cipher.update secret
      encrypted << cipher.final
      Base64.encode64(encrypted).chomp
    end

    # Public: Decrypts a secret
    #
    # secret - the encrypted string to be decrypted
    #
    # Returns the plain text decrypted string
    def decrypt(encrypted)
      cipher = create_cipher(:decrypt)
      plaintxt = cipher.update Base64.decode64(encrypted)
      plaintxt << cipher.final
    end



    private

      # Internal: Parses a key string into three components used by the
      # encryption ciphers.  The components are stored as private
      # instance variables.  Keeping it all in a single string
      # simplifies storing the key in environment variables.
      #
      # key - the key to be parsed
      #
      # Returns the key parsed into three components (iv,pwd,salt)
      def parse_key(key)
        parsed = key.split('$')
        if parsed.length != 3
          raise "Bad key format - generate a new one"
        else
          parsed
        end
      end


      # Internal: Create an encryption cipher
      #
      # mode - Set the mode to either :encrypt or :decrypt
      #
      # Returns a cipher to be used for encryption or decryption
      def create_cipher(mode)
        create_cipher_simple(mode)
      end

      # Internal: Create a simple encryption cipher
      #
      # mode - Set the mode to either :encrypt or :decrypt
      #
      # Returns a cipher to be used for encryption or decryption
      def create_cipher_simple(mode)
        iv,pwd,salt = parse_key(@key)

        cipher = OpenSSL::Cipher.new 'AES-128-CBC'
        cipher.send(mode)

        cipher.iv = iv
        cipher.key = pwd
        cipher
      end


      # Future: Create a cipher using the more secure pbkdf2_mac method
      #
      # This one is more secure but doesn't work on Heroku
      # Would like to optionally detect OpenSSL version 
      # and use this if possible 
      def create_cipher_pbkdf2(mode)
        iv,pwd,salt = parse_key(@key)

        cipher = OpenSSL::Cipher.new 'AES-128-CBC'
        cipher.send(mode)
        cipher.iv = iv

        digest = OpenSSL::Digest::SHA256.new
        key_len = cipher.key_len
        iter = 20000
        cipher.key = OpenSSL::PKCS5.pbkdf2_hmac(pwd, salt, iter, key_len, digest)
        cipher
      end
  end
end
