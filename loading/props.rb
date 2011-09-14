header do
  logo :players => "image", :image => "images/logo_and_tagline.png" #, :width => 250
end
divider
success :text => "Login successful!"
body :id => :body do
  para :text => "If you'd like to get a fresh batch of data..."
  load_button :id => :fresh_load_button, :text => "Load Fresh Data", :styles => "clean_button", :on_mouse_clicked => "scene.fresh_load"
end


