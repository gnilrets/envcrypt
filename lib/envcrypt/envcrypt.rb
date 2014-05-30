module Envcrypt

  class Envcryptor

    attr_accessor :key

    def initialize(key: ENV['ENVCRYPT_KEY'])
      @key = key == nil ? generate_key : parse_key(key)
      @de_cipher = nil
      @en_cipher = nil
    end


    def parse_key(key)
      @iv, @pwd, @salt = key.split('$')
      @key = key
    end


    def generate_key
      parse_key("#{SecureRandom.base64}$#{SecureRandom.base64(32)}$#{SecureRandom.base64}")
    end


    def encrypt(secret)
      create_encrypt_cipher

      encrypted = @encrypt_cipher.update secret
      encrypted << @encrypt_cipher.final
      Base64.encode64(encrypted).chomp
    end

    def decrypt(encrypted)
      create_decrypt_cipher
      plaintxt = @decrypt_cipher.update Base64.decode64(encrypted)
      plaintxt << @decrypt_cipher.final
    end


    private

      def create_encrypt_cipher
        @encrypt_cipher = create_cipher(:encrypt)
      end

      def create_decrypt_cipher
        @decrypt_cipher = create_cipher(:decrypt)
      end

      def create_cipher(mode)
        cipher = OpenSSL::Cipher.new 'AES-128-CBC'
        cipher.send(mode)
        cipher.iv = @iv

        digest = OpenSSL::Digest::SHA256.new
        key_len = cipher.key_len
        iter = 20000
        cipher.key = OpenSSL::PKCS5.pbkdf2_hmac(@pwd, @salt, iter, key_len, digest)
        cipher
      end


  end




  # Public: generate an encryption key to be set as an environment variable
  #
  # Returns an encrypted string
  def self.generate_key
    "#{SecureRandom.base64}$#{SecureRandom.base64(32)}$#{SecureRandom.base64}"
  end


  # Public: encrypt a string
  #
  # secret - The string to be encrypted
  #
  # Returns an encrypted string
  def encrypt(secret)
  end

  # Public: decrypt a string
  #
  # encrypted - The encrypted string
  #
  # Returns a plantext decryption of the encrypted string
  def decrypt(encrypted)
  end


  # Private: create cipher
  #
  # mode - Set up cipher in :encrypt or :decrypt mode
  #
  # Returns an OpenSSL::Cipher instance
  def self.create_cipher(mode)
  end
  private_class_method :create_cipher


end
