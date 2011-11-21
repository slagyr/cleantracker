header do
  logo :players => "image", :image => "images/logo_and_tagline.png" #, :width => 250
end
divider
login_pane do
  para :text => "Welcome to CleanTracker.  Please login below to begin viewing CleanCoders data.", :bottom_margin => 50
  login_param do
    login_label :text => "Username:"
    login_field :id => :username_field, :players => "text_box"
  end
  login_param do
    login_label :text => "Password:"
    login_field :id => :password_field, :players => "password_box"
  end
  buttons do
    login_button :id => :login_button, :text => "Login", :styles => "clean_button"
  end
end
error :id => "error_message", :text => "This is a sample error", :transparency => 100