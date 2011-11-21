module LoginButton

  def mouse_clicked(e)
    username = scene.find(:username_field).text
    password = scene.find(:password_field).text
    production.director.login(:username => username, :password => password)
  end

end