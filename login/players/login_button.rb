module LoginButton

  def mouse_clicked(e)
    username = scene.find(:username_field).text
    password = scene.find(:password_field).text
    production.clean_client = Cleandata::Client.new(:username => username, :password => password, :host => "localhost", :port => 8080)
    begin
      production.clean_client.connection
      production.producer.open_scene("loading", production.theater["default"])
    rescue Exception => e
      scene.find(:error_message).text = "Failed to login: #{e.message}"
      scene.find(:error_message).style.transparency = "0"
    end
  end
end