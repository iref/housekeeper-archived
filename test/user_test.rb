require 'test_helper'

describe User do
  
  setup do
    @db = mock()
    @collection = mock()
    @db.expects(:[]).with("users").return(@collection)
  end

  describe "should save user" do
    subject do
      User.new @db
    end

    val expectedDoc = {"send_sms" => true,
                       "google_token" => "abcd",
                       "email" => "my@email.com",
                       "default_group" => "mygroup"}
    @collection.expects(:insert).with(expectedDoc).once

    subject.save({:send_sms => true,
                  :google_token => "abcd",
                  :email => "my@email.com",
                   :default_group => "mygroup"})          
  end
end