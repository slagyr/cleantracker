graphs {
  extends :scene
}

body {
  top_padding 10
}

chart_list {
  width 165
  height 425
  vertical_scrollbar :on
}

link_group {
  extends :para
  width "100%"
  horizontal_alignment :center
  text_color "#6D6F71"
  top_margin 10
  font_size 14
}

chart_link {
  extends :para
  width "100%"
  font_size 12
  top_margin 5
  hover {
    text_color "#4DC5E0"
  }
}

chart_frame {
  width :greedy
  min_height 400
  horizontal_alignment :center
  vertical_alignment :center
}

chart_title {
  extends :para
  width "100%"
  font_size 20
  font_style "bold"
  horizontal_alignment :center
}

chart {
}
