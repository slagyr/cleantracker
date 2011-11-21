JARS = {
        "appengine-remote-api-1.5.1.jar" => "http://gaeshi-mvn.googlecode.com/svn/trunk/releases/com/google/appengine/appengine-remote-api/1.5.1/appengine-remote-api-1.5.1.jar",
        "appengine-api-1.0-sdk-1.5.1.jar" => "http://gaeshi-mvn.googlecode.com/svn/trunk/releases/com/google/appengine/appengine-api-1.0-sdk/1.5.1/appengine-api-1.0-sdk-1.5.1.jar"
}

desc "Download/install required jars"
task :jars do
  Dir.chdir "lib"
  JARS.each do |file, url|
    if File.exists?(file)
      puts "already installed #{file}"
    else
      puts "downloading #{file}"
      system "wget #{url}"
    end
  end
end

namespace :bundle do

  desc "Basic bundle install"
  task :install do
    system "bundle install"
  end

  desc "Installed a local bundle for production"
  task :standalone do
		system "rm Gemfile.lock"
    system "bundle install --standalone --path=gems --without=development"
  end

end

desc "Initialize the dev environment"
task :init => %w{jars bundle:install bundle:standalone}

require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec)
