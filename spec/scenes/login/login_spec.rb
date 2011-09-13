require File.expand_path(File.dirname(__FILE__) + "/../spec_helper")
require 'cleandata/client'

describe "Login" do

  uses_limelight :scene => "login", :hidden => true

  before do
    @client = mock("Cleandata::Client")
  end

  it "has login fields" do
    username_field = scene.find(:username_field)
    username_field.text.should == ""

    password_field = scene.find(:password_field)
    password_field.players.include?("password_box").should == true

    login_button = scene.find(:login_button)
    login_button.text.should == "Login"
  end

  it "fails to login with invalid credentials" do
    scene.find(:username_field).text = "blah"
    scene.find(:password_field).text = "blah"
    Cleandata::Client.should_receive(:new).with(:username => "blah", :password => "blah").and_return(@client)
    @client.should_receive(:connection).and_raise("Nope!")

    scene.find(:login_button).mouse_clicked(nil)

    production.clean_client.should == @client
    scene.find(:error_message).text.should == "Failed to login: Nope!"
  end

  it "succeeds to login" do
    scene.find(:username_field).text = "blah"
    scene.find(:password_field).text = "blah"
    Cleandata::Client.should_receive(:new).with(:username => "blah", :password => "blah").and_return(@client)
    @client.should_receive(:connection).and_return("some connection object")
    producer.should_receive(:open_scene).with("loading", production.theater["default"])

    scene.find(:login_button).mouse_clicked(nil)
  end

end