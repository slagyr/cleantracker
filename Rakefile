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

desc "Initialize the dev environment"
task :init => [:jars] do
  system "bundle install"
  system "bundle install --standalone --path=gems --without=development"
end