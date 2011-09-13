module ChartLink

  def mouse_clicked(e)
    load_method = "load_#{id}_chart".to_sym
    production.director.send(load_method)
  end

end