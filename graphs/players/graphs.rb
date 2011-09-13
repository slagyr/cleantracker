module Graphs

  def casted(e=nil)
    production.director.view = self
    production.director.load_viewer_history_chart
  end

  def display_chart(title, image_path)
    find(:chart_frame).build do
      chart_title :id => :chart_title, :text => title
      chart :id => :chart, :players => "image", :image => image_path
    end
  end

end