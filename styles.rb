scene {
  background_color "#3A3A3A"
  secondary_background_color "#1e1e1e"
  gradient :on
  gradient_angle 270
  gradient_penetration "20%"
  padding 15
  width "100%"
  height "100%"
  horizontal_alignment :center
}

header {
  bottom_padding 5
  width "100%"
}

divider {
  width "100%"
  height 4
  border_color "#6D6F71"
  border_width 0
  top_border_width 1
  bottom_border_width 1
}

para {
  text_color "#CCC"
  font_face "Helvetica"
  font_size 16
}

buttons {
  width "100%"
  horizontal_alignment :center
}

clean_button {
  background_color "#BDDBE4"
  secondary_background_color "#4099AF"
  gradient_angle 270
  gradient_penetration "50%"
  gradient :on
  font_size 20
  font_face "Helvetica"
  font_style "bold"
  text_color :white
  padding 10
  left_padding 20
  right_padding 20
  rounded_corner_radius 3
  horizontal_alignment :center
  hover {
    secondary_background_color "#53C6E3"
  }
}

success {
  extends :para
  width "100%"
  top_margin 20
  padding 5
  border_width 1
  vertical_alignment :center
  horizontal_alignment :center
  text_color "#149931"
  border_color "#149931"
  background_color "#91F587"
}

error {
  extends :success
  text_color "#A62315"
  border_color "#A62315"
  background_color "#FFA197"
}