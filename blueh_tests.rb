require "test/unit"

require File.expand_path(File.dirname(__FILE__) + '/blueh.rb')

class TestBlueh < Test::Unit::TestCase
  def test_on_sample_input
    input_file = "sample_input.txt"
    properties_file = "sample_vacation_rentals.json"
    stay_dates = parse_stay_dates(input_file)
    properties = parse_properties(properties_file)
    costs = get_costs(stay_dates, properties) unless stay_dates.nil? or properties.nil?
    assert_equal([{:name=>"Fern Grove Lodge", :cost=>2474.79}, {:name=>"Paradise Inn", :cost=>3508.65}, {:name=>"Honu's Hideaway", :cost=>2233.25}], costs)
  end 
  
  def test_future_dates_leap_year
    properties_file = "sample_vacation_rentals.json"
    stay_dates = (Date.parse("2012/05/07")..Date.parse("2012/05/20") - 1).to_a 
    properties = parse_properties(properties_file)
    costs = get_costs(stay_dates, properties) unless stay_dates.nil? or properties.nil?
    assert_equal([{:name=>"Fern Grove Lodge", :cost=>2474.79}, {:name=>"Paradise Inn", :cost=>3508.65}, {:name=>"Honu's Hideaway", :cost=>2233.25}], costs)
  end
  
  def test_leap_year
    properties_file = "sample_vacation_rentals.json"
    stay_dates = (Date.parse("2012/02/28")..Date.parse("2012/03/01") - 1).to_a 
    properties = parse_properties(properties_file)
    costs = get_costs(stay_dates, properties) unless stay_dates.nil? or properties.nil?
    assert_equal([{:name=>"Fern Grove Lodge", :cost=>560.13}, {:name=>"Paradise Inn", :cost=>645.51}, {:name=>"Honu's Hideaway", :cost=>343.58}], costs)
  end
  
  def test_past_dates
    properties_file = "sample_vacation_rentals.json"
    stay_dates = (Date.parse("2009/05/07")..Date.parse("2009/05/20") - 1).to_a 
    properties = parse_properties(properties_file)
    costs = get_costs(stay_dates, properties) unless stay_dates.nil? or properties.nil?
    assert_equal([{:name=>"Fern Grove Lodge", :cost=>2474.79}, {:name=>"Paradise Inn", :cost=>3508.65}, {:name=>"Honu's Hideaway", :cost=>2233.25}], costs)
  end
end