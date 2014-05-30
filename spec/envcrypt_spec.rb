$LOAD_PATH << '../lib'

require 'rubygems'
require 'bundler/setup'

require 'envcrypt'

#include Envcrypt


describe Envcrypt do
  describe "generating a key" do
    let(:key) { Envcrypt.generate_key }

    it "should have a length of 94" do
      expect(key.length).to eq 94
    end

    it "should parse into 3 components delimited by $" do
      expect(key.split("$").length).to eq 3
    end
  end


  it "should encrypt a password" do
    password = "mysecret"
    key = Envcrypt.generate_key
    encrypted = Envcrypt.encrypt(password)
    decrypted = Envcrypt.decrypt(encrypted)
    expect(decrypted).to eq password
  end
end
