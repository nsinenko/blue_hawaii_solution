require 'json'
require 'date'
require File.expand_path(File.dirname(__FILE__) + '/property.rb')

def parse_properties(file_name)
  properties = []
  
  if File.exists?(file_name)
    serialized = File.read(file_name)
    
    begin 
      data = JSON.parse(serialized) 
    rescue 
      puts 'Cannot parse json file' 
    end

    data.each do |f|
      properties << Property.new(f)
    end unless data.nil?
    
  else
    puts 'Properties file not found'
  end
  
  # check if the file has data
  unless properties
    puts 'No properties found' 
  end
  
  properties
end

def get_costs(stay_dates, properties)
  costs = []
  properties.each do |property|
    costs << property.quote(stay_dates)
  end
  
  costs
end

def parse_stay_dates(file_name)
  if File.exists?(file_name)    
    input_string = File.read(file_name)
    date_pattern = /[0-9]{2}(?:[0-9]{2})\/[0-1][0-9]\/[0-3][0-9]/
    start_date = date_pattern.match(input_string)
    if start_date
      end_date = date_pattern.match(start_date.post_match)
      stay_dates = (Date.parse(start_date.to_s)..Date.parse(end_date.to_s) - 1).to_a
      stay_dates
    else
      puts 'Input file format is incorrect'
    end
  else
    puts 'Input file not found'
  end
end

input_file = "input.txt"
properties_file = "vacation_rentals.json"

stay_dates = parse_stay_dates(input_file)
properties = parse_properties(properties_file)
costs = get_costs(stay_dates, properties) unless stay_dates.nil? or properties.nil?

if costs
  costs.each do |quote|
    puts "#{quote[:name]}: $#{quote[:cost]}"
  end
end