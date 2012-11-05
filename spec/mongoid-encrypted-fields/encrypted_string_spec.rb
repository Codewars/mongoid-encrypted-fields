require 'spec_helper'

module Mongoid
  describe EncryptedString do

    before(:all) do
      EncryptedStrings::SymmetricCipher.default_algorithm = 'aes-256-cbc'
      EncryptedStrings::SymmetricCipher.default_password = 'my test password'
    end

    let(:raw) { "abc123" }
    let(:raw_encrypted) { "abc123".encrypt(:symmetric) }

    it "returns the same string" do
      EncryptedString.new(raw).should eq(raw)
    end

    it "should encrypt the string" do
      EncryptedString.new(raw).encrypted.should eq(raw_encrypted)
    end

    it "nil should fail" do
      ->{ EncryptedString.new(nil) }.should raise_error()
    end

    describe "demongoize" do

      it "nil should return nil" do
        EncryptedString.demongoize(nil).should be_nil
      end

      it "empty string should return empty string" do
        EncryptedString.demongoize('').should eq('')
      end

      it "encrypted string should return instance of EncryptedString" do
        EncryptedString.demongoize(raw_encrypted).is_a?(EncryptedString).should be_true
      end

      it "encrypted string should return unencrypted string" do
        EncryptedString.demongoize(raw_encrypted).should eq(raw)
      end

    end

    describe "mongoize" do

      it "encrypted string should return encrypted" do
        EncryptedString.mongoize(EncryptedString.new(raw)).should eq(raw_encrypted)
      end

      it "encrypted string should return itself" do
        EncryptedString.mongoize(raw_encrypted).should be(raw_encrypted)
      end

      it "nil should return nil" do
        EncryptedString.mongoize(nil).should eq(nil)
      end

      it "empty string should return empty string" do
        EncryptedString.mongoize('').should eq('')
      end

      it "non empty string should return encrypted" do
        EncryptedString.mongoize(raw).should eq(raw_encrypted)
      end

    end

    describe "evolve" do

      it "encrypted string should return encrypted" do
        EncryptedString.evolve(EncryptedString.new(raw)).should eq(raw_encrypted)
      end

      it "encrypted string should return itself" do
        EncryptedString.evolve(raw_encrypted).should be(raw_encrypted)
      end

      it "nil should return nil" do
        EncryptedString.evolve(nil).should eq(nil)
      end

      it "empty string should return empty string" do
        EncryptedString.evolve('').should eq('')
      end

      it "non empty string should return encrypted" do
        EncryptedString.evolve(raw).should eq(raw_encrypted)
      end

    end

  end
end