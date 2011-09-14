module Graphs

  DEFAULT_OPTIONS = {:width => 600, :height => 375}

  def scene_opened(e=nil)
    production.director.graph_scene_ready(self, DEFAULT_OPTIONS)
  end

  def chart_loading
    find(:chart_frame).remove_all
    find(:chart_frame).build do
      para :text => "Your graph is loading..."
    end
  end

  def load_chart(id)
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