class Rank < ActiveRecord::Base

	def self.scrapeData
		#@cur_week_results = Keyval.where(:key => 'cur_week').at(0)
		#@cur_week = @cur_week_results.value
		max_week_checks_sql = "SELECT website, week, year FROM ranks r1 WHERE week IN ( SELECT week FROM ranks WHERE website=r1.website ORDER BY week DESC LIMIT 1) GROUP BY website, week, year;"
		max_week_results = Rank.find_by_sql(max_week_checks_sql)
		max_weeks = {}
		max_week_results.each do |max_week|
			max_weeks[max_week.website] = max_week.week
		end

		puts "scraping..."

		# get most recent publish checker for each website
		pub_checks_sql = "SELECT * FROM publish_checkers p WHERE (year, week) 
			IN (SELECT year, week FROM publish_checkers p2 WHERE p.website=p2.website ORDER BY year DESC, week DESC LIMIT 1);"
		pub_checks_query = PublishChecker.find_by_sql(pub_checks_sql)
		pub_checks = {}
 		pub_checks_query.each do |pub_check|
 			pub_check_array = [pub_check.publish_tok, pub_check.week, pub_check.year]
 		pub_checks[pub_check.website] = pub_check_array
 		end

		url_ind = 0
		rank_ind = 1
		rank_regex_ind = 2
		name_ind = 3
		name_regex_ind = 4
		desc_ind = 5
		desc_regex_ind = 6
		pub_check_ind = 7
		pub_check_regex = 8

		# SCRAPING ALGORITHM
		#driver = Selenium::WebDriver.for :firefox

		client = Selenium::WebDriver::Remote::Http::Default.new
		driver = Selenium::WebDriver.for :phantomjs
		driver = Selenium::WebDriver.for(:phantomjs, :http_client => client)

		# get most recent website record for each website
		websites_query = "SELECT * FROM scrape_configs s WHERE (year, week) 
			IN (SELECT year, week FROM scrape_configs s2 WHERE s.website=s2.website ORDER BY year DESC, week DESC LIMIT 1);"
		websites_results = ScrapeConfig.find_by_sql(websites_query)
		websites = {}
		websites_results.each do |website_rec|
			web_arr = [website_rec.url, website_rec.rank_xpath, website_rec.rank_regex, 
				website_rec.team_xpath, website_rec.team_regex, website_rec.description_xpath,
				website_rec.description_regex, website_rec.update_checker_xpath, website_rec.update_checker_regex]
			websites[website_rec.website] = web_arr
		end

		websites.each_key do |site|
			if site == "BI"
				next
			end
			puts "\tsite: #{site}"
			driver.get "#{websites[site][url_ind]}" # get request for website
			cur_pub = driver.find_elements :xpath => "#{websites[site][pub_check_ind]}"

			cur_pub_HTML = ""
			if !cur_pub[0].nil?
				cur_pub_HTML = "#{cur_pub[0].attribute('outerHTML')}"
			end 

			if pub_checks[site].nil?
				puts "adding new publish token for: #{site} as: #{cur_pub_HTML}"
				PublishChecker.create(:website => site, :publish_tok => cur_pub_HTML, :week => -1, :year => -1)
				pub_checks[site][1] = -1 # set default week to -1
				pub_checks[site][2] = 2015 # set default year to 2015
			elsif cur_pub_HTML != pub_checks[site][0]
				PublishChecker.create(:website => site, :publish_tok => cur_pub_HTML, :week => pub_checks[site][1] + 1, :year => pub_checks[site][2])				
				pub_checks[site][1] = pub_checks[site][1] + 1 # increment week but not year, year likely onlly to change on manual entry
			end

			if pub_checks[site].nil? || cur_pub_HTML != pub_checks[site][0]
				pub_checks[site][0] = cur_pub_HTML # set HTML publish token
				puts "adding new records to the database because tokens have changed (or first visit)"

				ranks = driver.find_elements :xpath => "#{websites[site][rank_ind]}"
				names = driver.find_elements :xpath => "#{websites[site][name_ind]}"
				descs = driver.find_elements :xpath => "#{websites[site][desc_ind]}"
				# Loop through and print to console every rank and team
				prev_rank = -1
				prev_prev_rank = -1
				for i in 0..(ranks.size - 1) do
					rank_outerHTML = "#{ranks[i].attribute('outerHTML')}" # outerHTML of element
					rank_match = rank_outerHTML.scan(Regexp.new("#{websites[site][rank_regex_ind]}")).join
					if rank_match == prev_rank
						if prev_prev_rank > prev_rank
							rank_match = rank_match.to_i - 1
						else
							rank_match = rank_match.to_i + 1
						end
					end
					prev_prev_rank = prev_rank
					prev_rank = rank_match
					puts rank_match

					name_outerHTML = "#{names[i].attribute('outerHTML')}"
					team_name = (name_outerHTML.scan(Regexp.new("#{websites[site][name_regex_ind]}")).join).strip
							name_match = "#{NAME_HASHES[site][team_name]}" # use mapped name

					desc_outerHTML = "#{descs[i].attribute('outerHTML')}"
					description_match = desc_outerHTML.scan(Regexp.new("#{websites[site][desc_regex_ind]}")).join.strip
					puts "creating record"
					Rank.create(:website => site, :team => name_match, :rank => rank_match, :description => description_match,
					 :week => pub_checks[site][1], :year => pub_checks[site][2])
				end
			end
		end

		# End the Selenium session
		driver.quit()
	end

	def self.scrapeSingle(site)
		#@cur_week_results = Keyval.where(:key => 'cur_week').at(0)
		#@cur_week = @cur_week_results.value
		max_week_checks_sql = "SELECT website, week, year FROM ranks r1 WHERE week IN ( SELECT week FROM ranks WHERE website=r1.website ORDER BY week DESC LIMIT 1) GROUP BY website, week, year;"
		max_week_results = Rank.find_by_sql(max_week_checks_sql)
		max_weeks = {}
		max_week_results.each do |max_week|
			max_weeks[max_week.website] = max_week.week
		end

		puts "scraping..."

		# get most recent publish checker for each website
		pub_checks_sql = "SELECT * FROM publish_checkers p WHERE (year, week) 
			IN (SELECT year, week FROM publish_checkers p2 WHERE p.website=p2.website ORDER BY year DESC, week DESC LIMIT 1);"
		pub_checks_query = PublishChecker.find_by_sql(pub_checks_sql)
		pub_checks = {}
 		pub_checks_query.each do |pub_check|
 			pub_check_array = [pub_check.publish_tok, pub_check.week, pub_check.year]
 		pub_checks[pub_check.website] = pub_check_array
 		end

		url_ind = 0
		rank_ind = 1
		rank_regex_ind = 2
		name_ind = 3
		name_regex_ind = 4
		desc_ind = 5
		desc_regex_ind = 6
		pub_check_ind = 7
		pub_check_regex = 8

		# SCRAPING ALGORITHM
		#driver = Selenium::WebDriver.for :firefox

		client = Selenium::WebDriver::Remote::Http::Default.new
		driver = Selenium::WebDriver.for :phantomjs
		driver = Selenium::WebDriver.for(:phantomjs, :http_client => client)

		# get most recent website record for each website
		websites_query = "SELECT * FROM scrape_configs s WHERE (year, week) 
			IN (SELECT year, week FROM scrape_configs s2 WHERE s.website=s2.website ORDER BY year DESC, week DESC LIMIT 1);"
		websites_results = ScrapeConfig.find_by_sql(websites_query)
		websites = {}
		websites_results.each do |website_rec|
			web_arr = [website_rec.url, website_rec.rank_xpath, website_rec.rank_regex, 
				website_rec.team_xpath, website_rec.team_regex, website_rec.description_xpath,
				website_rec.description_regex, website_rec.update_checker_xpath, website_rec.update_checker_regex]
			websites[website_rec.website] = web_arr
		end

		puts "\tsite: #{site}"
		driver.get "#{websites[site][url_ind]}" # get request for website
		cur_pub = driver.find_elements :xpath => "#{websites[site][pub_check_ind]}"

		cur_pub_HTML = ""
		if !cur_pub[0].nil?
			cur_pub_HTML = "#{cur_pub[0].attribute('outerHTML')}"
		end 

		if pub_checks[site].nil?
			puts "adding new publish token for: #{site} as: #{cur_pub_HTML}"
			PublishChecker.create(:website => site, :publish_tok => cur_pub_HTML, :week => -1, :year => -1)
			pub_checks[site][1] = -1 # set default week to -1
			pub_checks[site][2] = 2015 # set default year to 2015
		elsif cur_pub_HTML != pub_checks[site][0]
			PublishChecker.create(:website => site, :publish_tok => cur_pub_HTML, :week => pub_checks[site][1] + 1, :year => pub_checks[site][2])				
			pub_checks[site][1] = pub_checks[site][1] + 1 # increment week but not year, year likely onlly to change on manual entry
		end

		if pub_checks[site].nil? || cur_pub_HTML != pub_checks[site][0]
			pub_checks[site][0] = cur_pub_HTML # set HTML publish token
			puts "adding new records to the database because tokens have changed (or first visit)"

			ranks = driver.find_elements :xpath => "#{websites[site][rank_ind]}"
			names = driver.find_elements :xpath => "#{websites[site][name_ind]}"
			descs = driver.find_elements :xpath => "#{websites[site][desc_ind]}"
			# Loop through and print to console every rank and team
			prev_rank = -1
			prev_prev_rank = -1
			for i in 0..(ranks.size - 1) do
				rank_outerHTML = "#{ranks[i].attribute('outerHTML')}" # outerHTML of element
				rank_match = rank_outerHTML.scan(Regexp.new("#{websites[site][rank_regex_ind]}")).join
				if rank_match == prev_rank
					if prev_prev_rank > prev_rank
						rank_match = rank_match.to_i - 1
					else
						rank_match = rank_match.to_i + 1
					end
				end
				prev_prev_rank = prev_rank
				prev_rank = rank_match
				puts rank_match

				name_outerHTML = "#{names[i].attribute('outerHTML')}"
				team_name = (name_outerHTML.scan(Regexp.new("#{websites[site][name_regex_ind]}")).join).strip
						name_match = "#{NAME_HASHES[site][team_name]}" # use mapped name

				desc_outerHTML = "#{descs[i].attribute('outerHTML')}"
				description_match = desc_outerHTML.scan(Regexp.new("#{websites[site][desc_regex_ind]}")).join.strip
				puts "creating record"
				Rank.create(:website => site, :team => name_match, :rank => rank_match, :description => description_match,
				 :week => pub_checks[site][1], :year => pub_checks[site][2])
			end
		end

		# End the Selenium session
		driver.quit()
	end


	def self.scrapeSingleWeek(site, week, year)
		#@cur_week_results = Keyval.where(:key => 'cur_week').at(0)
		#@cur_week = @cur_week_results.value
		max_week_checks_sql = "SELECT website, week, year FROM ranks r1 WHERE week IN ( SELECT week FROM ranks WHERE website=r1.website ORDER BY week DESC LIMIT 1) GROUP BY website, week, year;"
		max_week_results = Rank.find_by_sql(max_week_checks_sql)
		max_weeks = {}
		max_week_results.each do |max_week|
			max_weeks[max_week.website] = max_week.week
		end

		puts "scraping..."

		# get most recent publish checker for each website
		pub_checks_sql = "SELECT * FROM publish_checkers p WHERE (year, week) 
			IN (SELECT year, week FROM publish_checkers p2 WHERE p.website=p2.website ORDER BY year DESC, week DESC LIMIT 1);"
		pub_checks_query = PublishChecker.find_by_sql(pub_checks_sql)
		pub_checks = {}
 		pub_checks_query.each do |pub_check|
 			pub_check_array = [pub_check.publish_tok, pub_check.week, pub_check.year]
 		pub_checks[pub_check.website] = pub_check_array
 		end

		url_ind = 0
		rank_ind = 1
		rank_regex_ind = 2
		name_ind = 3
		name_regex_ind = 4
		desc_ind = 5
		desc_regex_ind = 6
		pub_check_ind = 7
		pub_check_regex = 8

		# SCRAPING ALGORITHM
		#driver = Selenium::WebDriver.for :firefox

		client = Selenium::WebDriver::Remote::Http::Default.new
		driver = Selenium::WebDriver.for :phantomjs
		driver = Selenium::WebDriver.for(:phantomjs, :http_client => client)

		# get most recent website record for each website
		websites_query = "SELECT * FROM scrape_configs s WHERE week = #{week} AND year = #{year} AND website = '#{site}';"
		websites_results = ScrapeConfig.find_by_sql(websites_query)
		websites = {}
		websites_results.each do |website_rec|
			web_arr = [website_rec.url, website_rec.rank_xpath, website_rec.rank_regex, 
				website_rec.team_xpath, website_rec.team_regex, website_rec.description_xpath,
				website_rec.description_regex, website_rec.update_checker_xpath, website_rec.update_checker_regex]
			websites[website_rec.website] = web_arr
		end

		puts "\tsite: #{site}"
		driver.get "#{websites[site][url_ind]}" # get request for website
		cur_pub = driver.find_elements :xpath => "#{websites[site][pub_check_ind]}"

		cur_pub_HTML = ""
		if !cur_pub[0].nil?
			cur_pub_HTML = "#{cur_pub[0].attribute('outerHTML')}"
		end 

		if pub_checks[site].nil?
			puts "adding new publish token for: #{site} as: #{cur_pub_HTML}"
			PublishChecker.create(:website => site, :publish_tok => cur_pub_HTML, :week => -1, :year => -1)
			pub_checks[site][1] = -1 # set default week to -1
			pub_checks[site][2] = 2015 # set default year to 2015
		elsif cur_pub_HTML != pub_checks[site][0]
			PublishChecker.create(:website => site, :publish_tok => cur_pub_HTML, :week => pub_checks[site][1] + 1, :year => pub_checks[site][2])				
			pub_checks[site][1] = pub_checks[site][1] + 1 # increment week but not year, year likely onlly to change on manual entry
		end

		if pub_checks[site].nil? || cur_pub_HTML != pub_checks[site][0]
			pub_checks[site][0] = cur_pub_HTML # set HTML publish token
			puts "adding new records to the database because tokens have changed (or first visit)"

			ranks = driver.find_elements :xpath => "#{websites[site][rank_ind]}"
			names = driver.find_elements :xpath => "#{websites[site][name_ind]}"
			descs = driver.find_elements :xpath => "#{websites[site][desc_ind]}"
			# Loop through and print to console every rank and team
			prev_rank = -1
			prev_prev_rank = -1
			for i in 0..(ranks.size - 1) do
				rank_outerHTML = "#{ranks[i].attribute('outerHTML')}" # outerHTML of element
				rank_match = rank_outerHTML.scan(Regexp.new("#{websites[site][rank_regex_ind]}")).join
				if rank_match == prev_rank
					if prev_prev_rank > prev_rank
						rank_match = rank_match.to_i - 1
					else
						rank_match = rank_match.to_i + 1
					end
				end
				prev_prev_rank = prev_rank
				prev_rank = rank_match
				puts rank_match

				name_outerHTML = "#{names[i].attribute('outerHTML')}"
				team_name = (name_outerHTML.scan(Regexp.new("#{websites[site][name_regex_ind]}")).join).strip
						name_match = "#{NAME_HASHES[site][team_name]}" # use mapped name

				desc_outerHTML = "#{descs[i].attribute('outerHTML')}"
				description_match = desc_outerHTML.scan(Regexp.new("#{websites[site][desc_regex_ind]}")).join.strip
				puts "creating record"
				Rank.create(:website => site, :team => name_match, :rank => rank_match, :description => description_match,
				 :week => pub_checks[site][1], :year => pub_checks[site][2])
			end
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

	NAME_HASHES["CBS"] = Hash.new
	NAME_HASHES["ESPN"] = Hash.new
	NAME_HASHES["FOX"] = Hash.new
	NAME_HASHES["USA"] = Hash.new
	NAME_HASHES["BR"] = Hash.new
	NAME_HASHES["Rant"] = Hash.new
	NAME_HASHES["BI"] = Hash.new
	NAME_HASHES["MLB"] = Hash.new

	NAME_HASHES["CBS"]["WAS"] = "Washington Nationals"
	NAME_HASHES["CBS"]["PIT"] = "Pittsburgh Pirates"
	NAME_HASHES["CBS"]["STL"] = "St. Louis Cardinals"
	NAME_HASHES["CBS"]["SEA"] = "Seattle Mariners"
	NAME_HASHES["CBS"]["CLE"] = "Cleveland Indians"
	NAME_HASHES["CBS"]["LAD"] = "Los Angeles Dodgers"
	NAME_HASHES["CBS"]["LAA"] = "Los Angeles Angels"
	NAME_HASHES["CBS"]["DET"] = "Detroit Tigers"
	NAME_HASHES["CBS"]["BAL"] = "Baltimore Orioles"
	NAME_HASHES["CBS"]["SF"] = "San Francisco Giants"
	NAME_HASHES["CBS"]["BOS"] = "Boston Red Sox"
	NAME_HASHES["CBS"]["KC"] = "Kansas City Royals"
	NAME_HASHES["CBS"]["TOR"] = "Toronto Blue Jays"
	NAME_HASHES["CBS"]["CHC"] = "Chicago Cubs"
	NAME_HASHES["CBS"]["CHW"] = "Chicago White Sox"
	NAME_HASHES["CBS"]["SD"] = "San Diego Padres"
	NAME_HASHES["CBS"]["NYM"] = "New York Mets"
	NAME_HASHES["CBS"]["NYY"] = "New York Yankees"
	NAME_HASHES["CBS"]["MIA"] = "Miami Marlins"
	NAME_HASHES["CBS"]["OAK"] = "Oakland Athletics"
	NAME_HASHES["CBS"]["MIL"] = "Milwaukee Brewers"
	NAME_HASHES["CBS"]["TB"] = "Tampa Bay Rays"
	NAME_HASHES["CBS"]["CIN"] = "Cincinnati Reds"
	NAME_HASHES["CBS"]["HOU"] = "Houston Astros"
	NAME_HASHES["CBS"]["TEX"] = "Texas Rangers"
	NAME_HASHES["CBS"]["MIN"] = "Minnesota Twins"
	NAME_HASHES["CBS"]["COL"] = "Colorado Rockies"
	NAME_HASHES["CBS"]["ATL"] = "Atlanta Braves"
	NAME_HASHES["CBS"]["ARI"] = "Arizona Diamondbacks"
	NAME_HASHES["CBS"]["PHI"] = "Philadelphia Phillies"

	NAME_HASHES["ESPN"]["Nationals"] = "Washington Nationals"
	NAME_HASHES["ESPN"]["Pirates"] = "Pittsburgh Pirates"
	NAME_HASHES["ESPN"]["Cardinals"] = "St. Louis Cardinals"
	NAME_HASHES["ESPN"]["Mariners"] = "Seattle Mariners"
	NAME_HASHES["ESPN"]["Indians"] = "Cleveland Indians"
	NAME_HASHES["ESPN"]["Dodgers"] = "Los Angeles Dodgers"
	NAME_HASHES["ESPN"]["Angels"] = "Los Angeles Angels"
	NAME_HASHES["ESPN"]["Tigers"] = "Detroit Tigers"
	NAME_HASHES["ESPN"]["Orioles"] = "Baltimore Orioles"
	NAME_HASHES["ESPN"]["Giants"] = "San Francisco Giants"
	NAME_HASHES["ESPN"]["Red Sox"] = "Boston Red Sox"
	NAME_HASHES["ESPN"]["Royals"] = "Kansas City Royals"
	NAME_HASHES["ESPN"]["Blue Jays"] = "Toronto Blue Jays"
	NAME_HASHES["ESPN"]["Cubs"] = "Chicago Cubs"
	NAME_HASHES["ESPN"]["White Sox"] = "Chicago White Sox"
	NAME_HASHES["ESPN"]["Padres"] = "San Diego Padres"
	NAME_HASHES["ESPN"]["Mets"] = "New York Mets"
	NAME_HASHES["ESPN"]["Yankees"] = "New York Yankees"
	NAME_HASHES["ESPN"]["Marlins"] = "Miami Marlins"
	NAME_HASHES["ESPN"]["Athletics"] = "Oakland Athletics"
	NAME_HASHES["ESPN"]["Brewers"] = "Milwaukee Brewers"
	NAME_HASHES["ESPN"]["Rays"] = "Tampa Bay Rays"
	NAME_HASHES["ESPN"]["Reds"] = "Cincinnati Reds"
	NAME_HASHES["ESPN"]["Astros"] = "Houston Astros"
	NAME_HASHES["ESPN"]["Rangers"] = "Texas Rangers"
	NAME_HASHES["ESPN"]["Twins"] = "Minnesota Twins"
	NAME_HASHES["ESPN"]["Rockies"] = "Colorado Rockies"
	NAME_HASHES["ESPN"]["Braves"] = "Atlanta Braves"
	NAME_HASHES["ESPN"]["Diamondbacks"] = "Arizona Diamondbacks"
	NAME_HASHES["ESPN"]["Phillies"] = "Philadelphia Phillies"

	NAME_HASHES["FOX"]["Nationals"] = "Washington Nationals"
	NAME_HASHES["FOX"]["Pirates"] = "Pittsburgh Pirates"
	NAME_HASHES["FOX"]["Cardinals"] = "St. Louis Cardinals"
	NAME_HASHES["FOX"]["Mariners"] = "Seattle Mariners"
	NAME_HASHES["FOX"]["Indians"] = "Cleveland Indians"
	NAME_HASHES["FOX"]["Dodgers"] = "Los Angeles Dodgers"
	NAME_HASHES["FOX"]["Angels"] = "Los Angeles Angels"
	NAME_HASHES["FOX"]["Tigers"] = "Detroit Tigers"
	NAME_HASHES["FOX"]["Orioles"] = "Baltimore Orioles"
	NAME_HASHES["FOX"]["Giants"] = "San Francisco Giants"
	NAME_HASHES["FOX"]["Red Sox"] = "Boston Red Sox"
	NAME_HASHES["FOX"]["Royals"] = "Kansas City Royals"
	NAME_HASHES["FOX"]["Blue Jays"] = "Toronto Blue Jays"
	NAME_HASHES["FOX"]["Cubs"] = "Chicago Cubs"
	NAME_HASHES["FOX"]["White Sox"] = "Chicago White Sox"
	NAME_HASHES["FOX"]["Padres"] = "San Diego Padres"
	NAME_HASHES["FOX"]["Mets"] = "New York Mets"
	NAME_HASHES["FOX"]["Yankees"] = "New York Yankees"
	NAME_HASHES["FOX"]["Marlins"] = "Miami Marlins"
	NAME_HASHES["FOX"]["Athletics"] = "Oakland Athletics"
	NAME_HASHES["FOX"]["Brewers"] = "Milwaukee Brewers"
	NAME_HASHES["FOX"]["Rays"] = "Tampa Bay Rays"
	NAME_HASHES["FOX"]["Reds"] = "Cincinnati Reds"
	NAME_HASHES["FOX"]["Astros"] = "Houston Astros"
	NAME_HASHES["FOX"]["Rangers"] = "Texas Rangers"
	NAME_HASHES["FOX"]["Twins"] = "Minnesota Twins"
	NAME_HASHES["FOX"]["Rockies"] = "Colorado Rockies"
	NAME_HASHES["FOX"]["Braves"] = "Atlanta Braves"
	NAME_HASHES["FOX"]["Diamondbacks"] = "Arizona Diamondbacks"
	NAME_HASHES["FOX"]["Phillies"] = "Philadelphia Phillies"

	NAME_HASHES["USA"]["Nationals"] = "Washington Nationals"
	NAME_HASHES["USA"]["Pirates"] = "Pittsburgh Pirates"
	NAME_HASHES["USA"]["Cardinals"] = "St. Louis Cardinals"
	NAME_HASHES["USA"]["Mariners"] = "Seattle Mariners"
	NAME_HASHES["USA"]["Indians"] = "Cleveland Indians"
	NAME_HASHES["USA"]["Dodgers"] = "Los Angeles Dodgers"
	NAME_HASHES["USA"]["Angels"] = "Los Angeles Angels"
	NAME_HASHES["USA"]["Tigers"] = "Detroit Tigers"
	NAME_HASHES["USA"]["Orioles"] = "Baltimore Orioles"
	NAME_HASHES["USA"]["Giants"] = "San Francisco Giants"
	NAME_HASHES["USA"]["Red Sox"] = "Boston Red Sox"
	NAME_HASHES["USA"]["Royals"] = "Kansas City Royals"
	NAME_HASHES["USA"]["Blue Jays"] = "Toronto Blue Jays"
	NAME_HASHES["USA"]["Cubs"] = "Chicago Cubs"
	NAME_HASHES["USA"]["White Sox"] = "Chicago White Sox"
	NAME_HASHES["USA"]["Padres"] = "San Diego Padres"
	NAME_HASHES["USA"]["Mets"] = "New York Mets"
	NAME_HASHES["USA"]["Yankees"] = "New York Yankees"
	NAME_HASHES["USA"]["Marlins"] = "Miami Marlins"
	NAME_HASHES["USA"]["Athletics"] = "Oakland Athletics"
	NAME_HASHES["USA"]["Brewers"] = "Milwaukee Brewers"
	NAME_HASHES["USA"]["Rays"] = "Tampa Bay Rays"
	NAME_HASHES["USA"]["Reds"] = "Cincinnati Reds"
	NAME_HASHES["USA"]["Astros"] = "Houston Astros"
	NAME_HASHES["USA"]["Rangers"] = "Texas Rangers"
	NAME_HASHES["USA"]["Twins"] = "Minnesota Twins"
	NAME_HASHES["USA"]["Rockies"] = "Colorado Rockies"
	NAME_HASHES["USA"]["Braves"] = "Atlanta Braves"
	NAME_HASHES["USA"]["Diamondbacks"] = "Arizona Diamondbacks"
	NAME_HASHES["USA"]["Phillies"] = "Philadelphia Phillies"

	NAME_HASHES["BR"]["Colorado Rockies"] = "Colorado Rockies"
	NAME_HASHES["BR"]["Philadelphia Phillies"] = "Philadelphia Phillies"
	NAME_HASHES["BR"]["Tampa Bay Rays"] = "Tampa Bay Rays"
	NAME_HASHES["BR"]["Cincinnati Reds"] = "Cincinnati Reds"
	NAME_HASHES["BR"]["Texas Rangers"] = "Texas Rangers"
	NAME_HASHES["BR"]["Houston Astros"] = "Houston Astros"
	NAME_HASHES["BR"]["Minnesota Twins"] = "Minnesota Twins"
	NAME_HASHES["BR"]["Arizona Diamondbacks"] = "Arizona Diamondbacks"
	NAME_HASHES["BR"]["Milwaukee Brewers"] = "Milwaukee Brewers"
	NAME_HASHES["BR"]["Cleveland Indians"] = "Cleveland Indians"
	NAME_HASHES["BR"]["Atlanta Braves"] = "Atlanta Braves"
	NAME_HASHES["BR"]["New York Mets"] = "New York Mets"
	NAME_HASHES["BR"]["San Diego Padres"] = "San Diego Padres"
	NAME_HASHES["BR"]["New York Yankees"] = "New York Yankees"
	NAME_HASHES["BR"]["Chicago Cubs"] = "Chicago Cubs"
	NAME_HASHES["BR"]["Chicago White Sox"] = "Chicago White Sox"
	NAME_HASHES["BR"]["Kansas City Royals"] = "Kansas City Royals"
	NAME_HASHES["BR"]["Miami Marlins"] = "Miami Marlins"
	NAME_HASHES["BR"]["Oakland Athletics"] = "Oakland Athletics"
	NAME_HASHES["BR"]["Baltimore Orioles"] = "Baltimore Orioles"
	NAME_HASHES["BR"]["Boston Red Sox"] = "Boston Red Sox"
	NAME_HASHES["BR"]["Toronto Blue Jays"] = "Toronto Blue Jays"
	NAME_HASHES["BR"]["Washington Nationals"] = "Washington Nationals"
	NAME_HASHES["BR"]["Pittsburgh Pirates"] = "Pittsburgh Pirates"
	NAME_HASHES["BR"]["Seattle Mariners"] = "Seattle Mariners"
	NAME_HASHES["BR"]["San Francisco Giants"] = "San Francisco Giants"
	NAME_HASHES["BR"]["St. Louis Cardinals"] = "St. Louis Cardinals"
	NAME_HASHES["BR"]["Detroit Tigers"] = "Detroit Tigers"
	NAME_HASHES["BR"]["Los Angeles Angels"] = "Los Angeles Angels"
	NAME_HASHES["BR"]["Los Angeles Dodgers"] = "Los Angeles Dodgers"

	NAME_HASHES["Rant"]["Colorado Rockies"] = "Colorado Rockies"
	NAME_HASHES["Rant"]["Philadelphia Phillies"] = "Philadelphia Phillies"
	NAME_HASHES["Rant"]["Tampa Bay Rays"] = "Tampa Bay Rays"
	NAME_HASHES["Rant"]["Cincinnati Reds"] = "Cincinnati Reds"
	NAME_HASHES["Rant"]["Texas Rangers"] = "Texas Rangers"
	NAME_HASHES["Rant"]["Houston Astros"] = "Houston Astros"
	NAME_HASHES["Rant"]["Minnesota Twins"] = "Minnesota Twins"
	NAME_HASHES["Rant"]["Arizona Diamondbacks"] = "Arizona Diamondbacks"
	NAME_HASHES["Rant"]["Milwaukee Brewers"] = "Milwaukee Brewers"
	NAME_HASHES["Rant"]["Cleveland Indians"] = "Cleveland Indians"
	NAME_HASHES["Rant"]["Atlanta Braves"] = "Atlanta Braves"
	NAME_HASHES["Rant"]["New York Mets"] = "New York Mets"
	NAME_HASHES["Rant"]["San Diego Padres"] = "San Diego Padres"
	NAME_HASHES["Rant"]["New York Yankees"] = "New York Yankees"
	NAME_HASHES["Rant"]["Chicago Cubs"] = "Chicago Cubs"
	NAME_HASHES["Rant"]["Chicago White Sox"] = "Chicago White Sox"
	NAME_HASHES["Rant"]["Kansas City Royals"] = "Kansas City Royals"
	NAME_HASHES["Rant"]["Miami Marlins"] = "Miami Marlins"
	NAME_HASHES["Rant"]["Oakland Athletics"] = "Oakland Athletics"
	NAME_HASHES["Rant"]["Baltimore Orioles"] = "Baltimore Orioles"
	NAME_HASHES["Rant"]["Boston Red Sox"] = "Boston Red Sox"
	NAME_HASHES["Rant"]["Toronto Blue Jays"] = "Toronto Blue Jays"
	NAME_HASHES["Rant"]["Washington Nationals"] = "Washington Nationals"
	NAME_HASHES["Rant"]["Pittsburgh Pirates"] = "Pittsburgh Pirates"
	NAME_HASHES["Rant"]["Seattle Mariners"] = "Seattle Mariners"
	NAME_HASHES["Rant"]["San Francisco Giants"] = "San Francisco Giants"
	NAME_HASHES["Rant"]["St. Louis Cardinals"] = "St. Louis Cardinals"
	NAME_HASHES["Rant"]["Detroit Tigers"] = "Detroit Tigers"
	NAME_HASHES["Rant"]["Los Angeles Angels"] = "Los Angeles Angels"
	NAME_HASHES["Rant"]["Los Angeles Dodgers"] = "Los Angeles Dodgers"

	NAME_HASHES["BI"]["Colorado Rockies"] = "Colorado Rockies"
	NAME_HASHES["BI"]["Philadelphia Phillies"] = "Philadelphia Phillies"
	NAME_HASHES["BI"]["Tampa Bay Rays"] = "Tampa Bay Rays"
	NAME_HASHES["BI"]["Cincinnati Reds"] = "Cincinnati Reds"
	NAME_HASHES["BI"]["Texas Rangers"] = "Texas Rangers"
	NAME_HASHES["BI"]["Houston Astros"] = "Houston Astros"
	NAME_HASHES["BI"]["Minnesota Twins"] = "Minnesota Twins"
	NAME_HASHES["BI"]["Arizona Diamondbacks"] = "Arizona Diamondbacks"
	NAME_HASHES["BI"]["Milwaukee Brewers"] = "Milwaukee Brewers"
	NAME_HASHES["BI"]["Cleveland Indians"] = "Cleveland Indians"
	NAME_HASHES["BI"]["Atlanta Braves"] = "Atlanta Braves"
	NAME_HASHES["BI"]["New York Mets"] = "New York Mets"
	NAME_HASHES["BI"]["San Diego Padres"] = "San Diego Padres"
	NAME_HASHES["BI"]["New York Yankees"] = "New York Yankees"
	NAME_HASHES["BI"]["Chicago Cubs"] = "Chicago Cubs"
	NAME_HASHES["BI"]["Chicago White Sox"] = "Chicago White Sox"
	NAME_HASHES["BI"]["Kansas City Royals"] = "Kansas City Royals"
	NAME_HASHES["BI"]["Miami Marlins"] = "Miami Marlins"
	NAME_HASHES["BI"]["Oakland A's"] = "Oakland Athletics"
	NAME_HASHES["BI"]["Baltimore Orioles"] = "Baltimore Orioles"
	NAME_HASHES["BI"]["Boston Red Sox"] = "Boston Red Sox"
	NAME_HASHES["BI"]["Toronto Blue Jays"] = "Toronto Blue Jays"
	NAME_HASHES["BI"]["&nbsp;Washington Nationals"] = "Washington Nationals"
	NAME_HASHES["BI"]["Pittsburgh Pirates"] = "Pittsburgh Pirates"
	NAME_HASHES["BI"]["Seattle Mariners"] = "Seattle Mariners"
	NAME_HASHES["BI"]["San Francisco Giants"] = "San Francisco Giants"
	NAME_HASHES["BI"]["St. Louis Cardinals"] = "St. Louis Cardinals"
	NAME_HASHES["BI"]["Detroit Tigers"] = "Detroit Tigers"
	NAME_HASHES["BI"]["Los Angeles Angels"] = "Los Angeles Angels"
	NAME_HASHES["BI"]["Los Angeles Dodgers"] = "Los Angeles Dodgers"

	NAME_HASHES["MLB"]["Nationals"] = "Washington Nationals"
	NAME_HASHES["MLB"]["Pirates"] = "Pittsburgh Pirates"
	NAME_HASHES["MLB"]["Cardinals"] = "St. Louis Cardinals"
	NAME_HASHES["MLB"]["Mariners"] = "Seattle Mariners"
	NAME_HASHES["MLB"]["Indians"] = "Cleveland Indians"
	NAME_HASHES["MLB"]["Dodgers"] = "Los Angeles Dodgers"
	NAME_HASHES["MLB"]["Angels"] = "Los Angeles Angels"
	NAME_HASHES["MLB"]["Tigers"] = "Detroit Tigers"
	NAME_HASHES["MLB"]["Orioles"] = "Baltimore Orioles"
	NAME_HASHES["MLB"]["Giants"] = "San Francisco Giants"
	NAME_HASHES["MLB"]["Red Sox"] = "Boston Red Sox"
	NAME_HASHES["MLB"]["Royals"] = "Kansas City Royals"
	NAME_HASHES["MLB"]["Blue Jays"] = "Toronto Blue Jays"
	NAME_HASHES["MLB"]["Cubs"] = "Chicago Cubs"
	NAME_HASHES["MLB"]["White Sox"] = "Chicago White Sox"
	NAME_HASHES["MLB"]["Padres"] = "San Diego Padres"
	NAME_HASHES["MLB"]["Mets"] = "New York Mets"
	NAME_HASHES["MLB"]["Yankees"] = "New York Yankees"
	NAME_HASHES["MLB"]["Marlins"] = "Miami Marlins"
	NAME_HASHES["MLB"]["Athletics"] = "Oakland Athletics"
	NAME_HASHES["MLB"]["Brewers"] = "Milwaukee Brewers"
	NAME_HASHES["MLB"]["Rays"] = "Tampa Bay Rays"
	NAME_HASHES["MLB"]["Reds"] = "Cincinnati Reds"
	NAME_HASHES["MLB"]["Astros"] = "Houston Astros"
	NAME_HASHES["MLB"]["Rangers"] = "Texas Rangers"
	NAME_HASHES["MLB"]["Twins"] = "Minnesota Twins"
	NAME_HASHES["MLB"]["Rockies"] = "Colorado Rockies"
	NAME_HASHES["MLB"]["Braves"] = "Atlanta Braves"
	NAME_HASHES["MLB"]["D-backs"] = "Arizona Diamondbacks"
	NAME_HASHES["MLB"]["Phillies"] = "Philadelphia Phillies"	
end
