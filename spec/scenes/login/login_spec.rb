require File.expand_path(File.dirname(__FILE__) + "/../spec_helper")
require 'cleandata/client'

describe "Login" do

  uses_limelight :scene => "login", :hidden => true

  it "sets itself as the view on director" do
    production.director.should_receive(:view=)
    scene
  end

  it "has login fields" do
    username_field = scene.find(:username_field)
    username_field.text.should == ""

    password_field = scene.find(:password_field)
    password_field.players.include?("password_box").should == true

    login_button = scene.find(:login_button)
    login_button.text.should == "Login"
  end

  it "delegates to director to login" do
    scene.find(:username_field).text = "blah"
    scene.find(:password_field).text = "blah"

    production.director.should_receive(:login).with(:username => "blah", :password => "blah")

    scene.find(:login_button).mouse_clicked(nil)
  end

  it "displays failed login" do
    scene.login_failed("Nope!")
    scene.find(:error_message).text.should == "Failed to login: Nope!"
  end

  it "succeeds to login" do
    scene # get scene loading out of the way
    producer.should_receive(:open_scene).with("loading", production.theater["default"])

    scene.login_succeeded
  end

end