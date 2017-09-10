require "filewatcher"
require "json"
require "optparse"

def elm_make(filename, debug, config={})
  system "elm-make #{filename} #{debug ? "--debug" : ""} --output=#{config["js_output_path"]}#{config["name"]}.js"
  puts "#{Time.now}: #{filename} compiled."
end

def sass_make(filename, config={})
    system "sass --no-cache --style compressed #{filename}:#{config["css_output_path"]}main.css"
    puts "#{Time.now}: #{filename} compiled."
end

debug = false
opt = OptionParser.new
opt.on("-d") { debug = true }
opt.parse(ARGV)

puts "start watch..."

config = JSON.load File.read("build-config.json")

elm_make "src/Main.elm", debug, config
sass_make "sass/main.sass", config

elmwatcher = FileWatcher.new("src/**/*")
thread1 = Thread.new(elmwatcher) { |w|
  w.watch { |filename|
    elm_make "src/Main.elm", debug, config
  }
}

sasswatcher = FileWatcher.new("sass/**/*")
thread2 = Thread.new(sasswatcher) { |w|
  w.watch { |filename|
    sass_make "sass/main.sass", config
  }
}

thread1.join
thread2.join
