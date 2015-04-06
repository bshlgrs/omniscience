require "json"
require "time" 

class Store
  def initialize
    @hash_map = Hash.new
  end

  def insert(thing)
    if @hash_map[thing]
      @hash_map[thing]
    else
      @hash_map[thing] = @hash_map.size
      @hash_map.size - 1
    end
  end

  def get(label)
    @hash_map[label]
  end
end

class Log
  attr_accessor :programs, :details, :activity_log, :wifi_log

  def initialize
    @programs = Store.new
    @details = Store.new
    @wifi_networks = Store.new
    @activity_log = []
    @wifi_log = []
  end

  def log_window
    response = add_raw_string(`osascript getWindowName.script`)

    eval("error = nil")
    stuff = eval("[#{response.chomp}]") # this is obviously really dumb
    @activity_log.add_parsed_string(stuff)
  end

  def log_wifi_network
    @wifi_log.push([Time.now, `networksetup -getairportnetwork en0`["".length..-1])
    # or perhaps `/System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources/airport -I`
  end

  def add_raw_string(string)
    eval("error = nil")
    stuff = eval("[#{string.chomp}]") # this is obviously really dumb
    add_parsed_string(stuff)
  end

  def add_parsed_string(info_array)
    program_code = @programs.insert(info_array.first)
    other_info = info_array.drop(1).map { |item| details.insert(item) }

    activity_log.push([Time.now, program_code] + other_info)
  end
end

$file_location = "~/.omniscience/usage_log.yaml"

def main
  log = begin
      YAML.load_file($file_location)
    rescue
      log = Log.new    
    end
  
  loop do

    log.log_window
    log.log_wifi_network

    p log.details
    File.open($file_location, 'w') {|f| f.write log.to_yaml }
  end
end

main