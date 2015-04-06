require "json"
require "time" 

class Log
  attr_accessor :programs, :details, :log

  def initialize
    @programs = []
    @details = []
    @log = []
  end

  def getEncodedProgramName(program_name)
    idx = programs.find_index(program_name)
    if idx
      idx
    else
      programs.push(program_name)
      programs.length - 1
    end
  end

  def getEncodedFileName(file_name)
    idx = details.find_index(file_name)
    if idx
      idx
    else
      details.push(file_name)
      details.length - 1
    end
  end

  def addRawString(string)
    eval("error = nil")
    stuff = eval("[#{string.chomp}]") # this is obviously really dumb
    addThing(stuff)
  end

  def addThing(info_array)
    program_code = getEncodedProgramName(info_array.first)
    other_info = info_array.drop(1).map { |item| getEncodedFileName(item) }

    log.push([Time.now(), program_code] + other_info)
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
    log.addRawString(`osascript getWindowName.script`)
    p log.details
    File.open($file_location, 'w') {|f| f.write log.to_yaml }
  end
end

main