require 'bigdecimal'

class Property  
  def initialize(f)
    @name = f['name']    
    @cleaning_fee = f['cleaning fee'] ? currency_to_float(f['cleaning fee']) : 0
    
    if f['seasons']
      @seasons = []
      @rate_for_day = {}
      
      f['seasons'].each do |season|        
        season_details = season[season.keys[0]]
        season_name = season.keys[0]
        season_start = Date.strptime(season_details['start'], '%m-%d')
        season_end = Date.strptime(season_details['end'], '%m-%d')

        if season_start > season_end 
          season_end = season_end.next_year end
        
        rate = currency_to_float(season_details['rate'])
        
        # create a hash with day numbers as keys and rate as value
        (season_start..season_end).each do |day|
          day_number = (day.leap? and day.month > 2) ? day.yday - 1 : day.yday # adjust for leap year
          @rate_for_day[day_number] = rate
        end
      end
    else
      @rate = currency_to_float(f['rate']) || 0
    end
  end
  
  def quote(stay_dates)
    total_rate = 0
    stay_dates.each do |day|
      if @seasons
        day_number = (day.leap? and day.month > 2) ? day.yday - 1 : day.yday # adjust for leap year
        total_rate += @rate_for_day[day_number]
      else
        total_rate += @rate
      end      
    end
    
    total_rate += @cleaning_fee
    total_rate *= 1.0411416 # add sales tax
    total_rate = ("%.2f" % total_rate.round(2)) # round to 2 decimal points    
      
    {:name => @name, :cost => total_rate }
  end
  
  private
  def currency_to_float(num)
    num.gsub!('$','').to_f
  end
end