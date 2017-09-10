require "net/http"
require "json"

def install_package(list)
  if list.length == 0
    puts "Package not found."
    return
  end
  list.each_with_index { |package, i|
    puts printf("%#{list.length.to_s.length}d: #{package}", i)
  }

  puts

  while true
    print "install id> "

    begin
      id = Integer(STDIN.gets.chomp)
      puts
      system "elm-package install #{list[id]} -y"
      break
    rescue ArgumentError
      puts "数値を入力してください"
    end
  end

end

Signal.trap(:INT) {
  exit 0
}

search_name = ARGV[0]
search_name ||= ""

res = Net::HTTP.get(URI.parse("http://package.elm-lang.org/new-packages"))

package_list = JSON.load(res)

find_packages = package_list.select { |package|
  package.include?(search_name)
}

install_package find_packages
