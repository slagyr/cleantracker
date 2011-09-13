# This file (stages.rb) is used to define the stages within your production.
#
# Below is an example statge configuration.
#
#  stage "center_stage" do
#    default_scene "main"
#    title "Limelight Center Stage"
#    location [0, 0]
#    size [300, 800]
#  end

stage "default" do
  #default_scene "loading"
  #default_scene "login"
  default_scene "graphs"
  title "CleanTracker"
  location [:center, :center]
  size [800, 600]
end

stage "devtool" do
  default_scene "devtool"
  title "Dev Tool"
  location [50, 25]
  size [100, 100]
  background_color "transparent"
  framed false
end

