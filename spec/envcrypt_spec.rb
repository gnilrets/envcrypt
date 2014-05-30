$LOAD_PATH << '../lib'

require 'rubygems'
require 'bundler/setup'

require 'envcrypt'

include Envcrypt


describe "Envcrypt" do
  describe "generating a key" do
    let(:encryptor) { Envcryptor.new() }

    it "should have a length of 94" do
      expect(encryptor.key.length).to eq 94
    end

    it "should parse into 3 components delimited by $" do
      expect(encryptor.key.split("$").length).to eq 3
    end
  end

  describe "encrypting a password" do
    let(:password) { "mysecret" }

    it "should encrypt and and decrypt a password from a new key" do
      crypt = Envcryptor.new()

      encrypted = crypt.encrypt(password)
      plaintxt = crypt.decrypt(encrypted)

      expect(plaintxt).to eq password
    end
  end
end
