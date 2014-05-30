module Envcrypt

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
