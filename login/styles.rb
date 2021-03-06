# This file, (styles.rb) inside a scene, should define any styles specific to the containing scene.
# It makes use of the StyleBuilder DSL.
#
# For more information see: http://limelightwiki.8thlight.com/index.php/A_Cook%27s_Tour_of_Limelight#Styling_with_styles.rb
# For a complete listing of style attributes see: http://limelightwiki.8thlight.com/index.php/Style_Attributes

login {
  extends :scene
}

login_pane {
  width 400
  top_padding 60
}

login_param {
  width "100%"
  horizontal_alignment :center
  vertical_alignment :center
  bottom_margin 30
}

login_label {
  top_padding 5
  text_color "#CCCCCC"
  font_size 20
  font_face "Helvetica"
  font_style "bold"
  width "30%"
  horizontal_alignment :right
  right_padding 15
}

login_field {
  width "70%"
  height 40
  font_size 16
  font_face "Helvetica"
  font_style "bold"
  text_color :red
}