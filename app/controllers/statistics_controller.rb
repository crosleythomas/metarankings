class StatisticsController < ApplicationController

	def index
		websites = ['CBS', 'FOX', 'ESPN', 'USA', 'BR', 'Rant', 'MLB']

		@avg_moves = {}

		websites.each do |site|
			sql_query = "SELECT week FROM ranks WHERE website='#{site}' GROUP BY week ORDER BY week DESC LIMIT 1;"
			sql_result = PublishChecker.find_by_sql(sql_query)
			num_weeks = sql_result[0].week

			total_moves = 0
			curr_ranks = {}
			sql_query = "SELECT rank, team FROM ranks WHERE website='#{site}' and week = 1 ORDER BY rank;"
			
			sql_result = Rank.find_by_sql(sql_query)
			sql_result.each do |ranking|
				curr_ranks[ranking.team] = ranking.rank
			end

			for i in 2..num_weeks - 1
				sql_query = "SELECT rank, team FROM ranks WHERE website='#{site}' and week = #{i} ORDER BY rank;"
				sql_result = Rank.find_by_sql(sql_query)
				next_ranks = {}
				sql_result.each do |ranking|
					next_ranks[ranking.team] = ranking.rank
				end

				curr_ranks.each do |team, rank|
					total_moves += (next_ranks[team] - rank).abs
				end
				curr_ranks = next_ranks
			end
			puts "#{site} #{total_moves} #{num_weeks}"
			@avg_moves[site] = (total_moves.to_f / (num_weeks.to_f * 30.0)).round(2)
		end
		render 'statistics/index'
	end



end