module Graphs

  DEFAULT_OPTIONS = {:width => 600, :height => 375}

  def scene_opened(e=nil)
    production.director.view = self
    load_chart(:viewer_history)
  end

  def load_chart(id)
    find(:chart_frame).remove_all
    find(:chart_frame).build do
      para :text => "Your graph is loading..."
    end
    load_method = "load_#{id}_chart".to_sym
    production.director.send(load_method, DEFAULT_OPTIONS)
  end

  def display_chart(title, image_path)
    find(:chart_frame).remove_all
    find(:chart_frame).build do
      chart_title :id => :chart_title, :text => title
      chart :id => :chart, :players => "image", :image => image_path
    end
  end

end