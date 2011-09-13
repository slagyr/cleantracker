module Cleantracker

  class Curl

    NAME_PARTS = ('0'..'9').to_a + ('a'..'z').to_a
    ROOT = "/tmp/cleantracker"

    def initialize
      Dir.mkdir(ROOT) if !File.exists?(ROOT)
    end

    def new_name
      name = ""
      10.times { name << NAME_PARTS[rand(36)] }
      name
    end

    def get(url)
      path = File.join(ROOT, new_name)
      output = `curl -o #{path} #{url} 2>&1`
      raise output unless $?.success?
      path
    end

  end

end