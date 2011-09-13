graphs {
  extends :scene
}

body {
  top_padding 10
}

chart_list {
  width 150
}

chart_link {
  extends :para
  width "100%"
  top_margin 5
  hover {
    text_color "#4DC5E0"
  }
}

chart_frame {
  width :greedy
  horizontal_alignment :center
  vertical_alignment :center
}

chart_title {
  extends :para
  width "100%"
  font_size "20"
  font_style "bold"
  horizontal_alignment :center
}
