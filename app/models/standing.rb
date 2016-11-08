class Standing < ActiveRecord::Base

	def self.scrapeData(new_url)
		puts "scraping..."

		#url = "http://mlb.mlb.com/mlb/standings/#20150509"
		url = new_url

		team_xpath = "//*[starts-with(@id, 'standingsTable')]/table/tbody//tr/td[1]/a"
		wins_xpath = "//*[starts-with(@id, 'standingsTable')]/table/tbody//tr/td[2]"
		losses_xpath = "//*[starts-with(@id, 'standingsTable')]/table/tbody//tr/td[3]"
		percentage_xpath = "//*[starts-with(@id, 'standingsTable')]/table/tbody//tr/td[4]"

		# SCRAPING ALGORITHM
		driver = Selenium::WebDriver.for :firefox

		#client = Selenium::WebDriver::Remote::Http::Default.new
		#driver = Selenium::WebDriver.for :phantomjs
		#driver = Selenium::WebDriver.for(:phantomjs, :http_client => client)

	    driver.get "#{url}" # get request for website

	    next_week_sql = "SELECT week FROM standings ORDER BY week DESC LIMIT 1"
	    next_week = Standing.find_by_sql(next_week_sql)
	    if next_week[0].nil?
	    	next_week = 1
	    else
		    next_week = next_week[0].week + 1
		end
	    next_year = 2015

	    teams = driver.find_elements :xpath => "#{team_xpath}"
	    wins = driver.find_elements :xpath => "#{wins_xpath}"
	    losses = driver.find_elements :xpath => "#{losses_xpath}"
	    percentages = driver.find_elements :xpath => "#{percentage_xpath}"

	    # Loop through and print to console every rank and team
	    for i in 0..(teams.size - 1) do
	        team = "#{teams[i].attribute('innerHTML')}"
	        team = NAME_HASHES[team]
	        win = "#{wins[i].attribute('innerHTML')}" # outerHTML of element
	        loss = "#{losses[i].attribute('innerHTML')}" # outerHTML of element
	        percentage = "#{percentages[i].attribute('innerHTML')}" # outerHTML of element


			puts "creating record: #{team} #{win} #{loss} #{percentage}"
			Standing.create(:team => team, :wins => win, :losses => loss, :percentage => percentage,
			 :week => next_week, :year => next_year)
	    end

	# End the Selenium session
	driver.quit()
	end


	#######################################################################################################################

	# Hashing from various names formats to a single standard

	# Hash Format 
	# Key: 		Un-standardized name
	# Value: 	Array of {standardized name, team's image url}

=begin

Standard:
	Colorado Rockies
	Philadelphia Phillies
	Tampa Bay Rays
	Cincinnati Reds
	Texas Rangers
	Houston Astros
	Minnesota Twins
	Arizona Diamondbacks
	Milwaukee Brewers
	Cleveland Indians
	Atlanta Braves
	New York Mets
	San Diego Padres
	New York Yankees
	Chicago Cubs
	Chicago White Sox
	Kansas City Royals
	Miami Marlins
	Oakland Athletics
	Baltimore Orioles
	Boston Red Sox
	Toronto Blue Jays
	Washington Nationals
	Pittsburgh Pirates
	Seattle Mariners
	San Francisco Giants
	St. Louis Cardinals
	Detroit Tigers
	Los Angeles Angels
	Los Angeles Dodgers

=end

	NAME_HASHES = Hash.new

	NAME_HASHES["Washington"] = "Washington Nationals"
	NAME_HASHES["Pittsburgh"] = "Pittsburgh Pirates"
	NAME_HASHES["St. Louis"] = "St. Louis Cardinals"
	NAME_HASHES["Seattle"] = "Seattle Mariners"
	NAME_HASHES["Cleveland"] = "Cleveland Indians"
	NAME_HASHES["LA Dodgers"] = "Los Angeles Dodgers"
	NAME_HASHES["LA Angels"] = "Los Angeles Angels"
	NAME_HASHES["Detroit"] = "Detroit Tigers"
	NAME_HASHES["Baltimore"] = "Baltimore Orioles"
	NAME_HASHES["San Francisco"] = "San Francisco Giants"
	NAME_HASHES["Boston"] = "Boston Red Sox"
	NAME_HASHES["Kansas City"] = "Kansas City Royals"
	NAME_HASHES["Toronto"] = "Toronto Blue Jays"
	NAME_HASHES["Chi Cubs"] = "Chicago Cubs"
	NAME_HASHES["Chi White Sox"] = "Chicago White Sox"
	NAME_HASHES["San Diego"] = "San Diego Padres"
	NAME_HASHES["NY Mets"] = "New York Mets"
	NAME_HASHES["NY Yankees"] = "New York Yankees"
	NAME_HASHES["Miami"] = "Miami Marlins"
	NAME_HASHES["Oakland"] = "Oakland Athletics"
	NAME_HASHES["Milwaukee"] = "Milwaukee Brewers"
	NAME_HASHES["Tampa Bay"] = "Tampa Bay Rays"
	NAME_HASHES["Cincinnati"] = "Cincinnati Reds"
	NAME_HASHES["Houston"] = "Houston Astros"
	NAME_HASHES["Texas"] = "Texas Rangers"
	NAME_HASHES["Minnesota"] = "Minnesota Twins"
	NAME_HASHES["Colorado"] = "Colorado Rockies"
	NAME_HASHES["Atlanta"] = "Atlanta Braves"
	NAME_HASHES["Arizona"] = "Arizona Diamondbacks"
	NAME_HASHES["Philadelphia"] = "Philadelphia Phillies"

end
