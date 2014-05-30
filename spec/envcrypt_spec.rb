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

  describe "encrypting and decrypting a password" do
    let(:password) { "mysecret" }

    describe "with a generated key" do
      it "should encrypt and decrypt properly" do
        crypt = Envcryptor.new()

        encrypted = crypt.encrypt(password)
        plaintxt = crypt.decrypt(encrypted)

        expect(plaintxt).to eq password
      end
    end

    describe "with a supplied environment variable" do
      before do
        ENV['ENVCRYPT_KEY'] = "UnY9w3T5Qk3Q5JshOp/2HA==$8swxKYQxgyXaCyvMb+wP2HwqalpiSc3K4MpCvOpD2QY=$RK2cUDUHNBmI7miJcd6W4g=="
        @crypt = Envcryptor.new()
      end

      it "should have set the correct key" do
        expect(@crypt.key).to eq ENV['ENVCRYPT_KEY']
      end

      it "should still encrypt and decrypt properly" do
        encrypted = @crypt.encrypt(password)
        plaintxt = @crypt.decrypt(encrypted)

        expect(plaintxt).to eq password
      end
    end
  end
end
