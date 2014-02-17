require 'test_helper'
require File.expand_path '../../app/api/circles.rb', __FILE__

include Rack::Test::Methods

def app
  Housekeeper::Circles
end

describe Housekeeper::Circles do

  before do
    token = Housekeeper::GoogleToken.new "access", "refresh", Time.now(), 3600
    @user = Housekeeper::User.new "octocat@github.com", token
    @user.save

    @userB = Housekeeper::User.new "octomama@github.com", token
    @userB.save

    @octocat_circle = Housekeeper::Circle.new "Octocat's Thruthful",
      "True octocat fans", @user.id
    @octocat_circle.save
    
    other_circle = Housekeeper::Circle.new "The other circle",
      "Not as cool circle as Octocat's Thruthful", @userB.id
    other_circle.save
  end

  after do
    Housekeeper::mongo["users"].remove()
    Housekeeper::mongo["circles"].remove()
  end
  
  it "should remove circle if user is moderator of circle" do
    delete "/circle/#{@octocat_circle.id}", {}, {'rack.session' => {:user => @user}}
    last_response.status.must_equal 201

    expected = Housekeeper::mongo["circles"].find({"_id" => BSON::ObjectId.from_string(@octocat_circle.id)})
    expected.has_next?.must_equal false
  end

  it "should return 403 if user is not moderator of circle" do
    delete "/circle/#{@octocat_circle.id}", {}, {'rack.session' => {:user => @userB}}
    last_response.status.must_equal 403

    expected = Housekeeper::mongo["circles"]
      .find({"_id" => BSON::ObjectId.from_string(@octocat_circle.id)})
    expected.has_next?.must_equal true
  end

  it "should return 401 if circle with given id does not exists" do
    delete "/circle/nonexistingid", {}, {'rack.session' => {:user => @user}}
    last_response.status.must_equal 401
  end
end
