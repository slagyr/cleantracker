module Loading

  prop_reader :loading_output
  attr_reader :dots

  def scene_opened(e=nil)
    production.director.loading_scene_ready(self)
  end

  def all_models_loaded
    production.producer.open_scene("graphs", production.theater["default"])
  end

  def enable_cache
    find(:body).build do
      para :text => "Or you can use the data from the previous loading..."
      load_button :id => :cache_load_button, :text => "Use Data From Privious Load", :styles => "clean_button", :on_mouse_clicked => "scene.cache_load"
    end
  end

  def fresh_load
    open_log
    production.director.load_clean_data
  end

  def cache_load
    open_log
    production.director.use_cached_data
  end

  def starting_load(model)
    log "Loading #{model} "
    @dots = animate(:updates_per_second => 4) { log ". " }
  end

  def finished_load
    @dots.stop if @dots
    log "DONE\n"
  end

  def open_log
    scene.find(:body).remove_all
    scene.find(:body).build do
      loading_pane :id => :loading_output, :text => ""
    end
  end

  def log(message)
    loading_output.text += message
  end

end