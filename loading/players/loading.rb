module Loading

  prop_reader :loading_output

  def scene_opened(e)
    begin
      %w{viewers codecasts licenses payments viewings downloads}.each do |model|
        load_data(model)
      end
      production.producer.open_scene("graphs", production.theater["default"])
    rescue Exception => e
      puts e
      puts e.backtrace
      log e
      log e.backtrace.join("\n")
    end
  end

  private

  def load_data(model)
    begin
      log "Loading #{model} "
      @dots = animate(:updates_per_second => 4) { log ". " }
      production.cache[model.to_sym] = production.clean_client.send(model.to_sym)
      log "DONE\n"
    ensure
      @dots.stop if @dots
    end
  end

  def log(message)
    loading_output.text += message
  end

end