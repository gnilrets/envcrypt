$LOAD_PATH << '../lib'

require 'rubygems'
require 'bundler/setup'

require 'envcrypt'

include Envcrypt


describe "Envcrypt" do
  describe "generating a key" do
    let(:encrypter) { Envcrypter.new() }

    it "should have a length of 94" do
      expect(encrypter.key.length).to eq 94
    end

    it "should parse into 3 components delimited by $" do
      expect(encrypter.key.split("$").length).to eq 3
    end
  end

  describe "encrypting and decrypting a password" do
    let(:password) { "mysecret" }

    describe "with a generated key" do
      it "should encrypt and decrypt properly" do
        crypt = Envcrypter.new()

        encrypted = crypt.encrypt(password)
        plaintxt = crypt.decrypt(encrypted)

        expect(plaintxt).to eq password
      end
    end


    describe "with a supplied environment variable" do
      before do
        ENV['ENVCRYPT_KEY'] = "UnY9w3T5Qk3Q5JshOp/2HA==$8swxKYQxgyXaCyvMb+wP2HwqalpiSc3K4MpCvOpD2QY=$RK2cUDUHNBmI7miJcd6W4g=="
        @crypt = Envcrypter.new()
      end

      after { ENV['ENVCRYPT_KEY'] = nil }

      it "should have set the correct key" do
        expect(@crypt.key).to eq ENV['ENVCRYPT_KEY']
      end

      it "should still encrypt and decrypt properly" do
        encrypted = @crypt.encrypt(password)
        plaintxt = @crypt.decrypt(encrypted)

        expect(plaintxt).to eq password
      end
    end


    describe "with a different password" do
      it "should encrypt to a different string" do
        crypt = Envcrypter.new()

        encrypted = crypt.encrypt(password)
        encrypted_different = crypt.encrypt("#{password}plus")

        expect(encrypted).not_to eq encrypted_different
      end
    end

    describe "with the same password but different key" do
      before do
        @crypt = Envcrypter.new()
        @crypt2 = Envcrypter.new()

        @encrypted = @crypt.encrypt(password)
        @encrypted2 = @crypt2.encrypt(password)
      end

      it "should encrypt to a different string" do
        expect(@encrypted).not_to eq @encrypted2
      end

      it "and they should still decrypt to the same password" do
        plaintxt = @crypt.decrypt(@encrypted)
        plaintxt2 = @crypt2.decrypt(@encrypted2)

        expect(plaintxt).to eq plaintxt2
      end
    end
  end
end
