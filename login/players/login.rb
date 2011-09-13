module Login

  def scene_opened(e=nil)
    production.director.view = self
  end

  def login_failed(message)
    scene.find(:error_message).text = "Failed to login: #{message}"
    scene.find(:error_message).style.transparency = "0"
  end

  def login_succeeded
    production.producer.open_scene("loading", production.theater["default"])
  end

end