module Loading

  prop_reader :loading_output
  attr_reader :dots

  def scene_opened(e=nil)
    production.director.view = self
  end

  def all_models_loaded
    production.producer.open_scene("graphs", production.theater["default"])
  end

  def starting_load(model)
    log "Loading #{model} "
    @dots = animate(:updates_per_second => 4) { log ". " }
  end

  def finished_load
    @dots.stop if @dots
    log "DONE\n"
  end

  def log(message)
    loading_output.text += message
  end

end