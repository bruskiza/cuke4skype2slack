require 'open-uri'
require 'json'
require 'sqlite3'
require 'yaml'

# __        ___    ____  _   _ ___ _   _  ____ _ 
# \ \      / / \  |  _ \| \ | |_ _| \ | |/ ___| |
#  \ \ /\ / / _ \ | |_) |  \| || ||  \| | |  _| |
#   \ V  V / ___ \|  _ <| |\  || || |\  | |_| |_|
#    \_/\_/_/   \_\_| \_\_| \_|___|_| \_|\____(_)
                                               
#  ____  _               _     _                       _ _             
# / ___|| |__   ___   __| | __| |_   _    ___ ___   __| (_)_ __   __ _ 
# \___ \| '_ \ / _ \ / _` |/ _` | | | |  / __/ _ \ / _` | | '_ \ / _` |
#  ___) | | | | (_) | (_| | (_| | |_| | | (_| (_) | (_| | | | | | (_| |
# |____/|_| |_|\___/ \__,_|\__,_|\__, |  \___\___/ \__,_|_|_| |_|\__, |
#                                |___/                           |___/ 
#        _                    _ _ 
#   __ _| |__   ___  __ _  __| | |
#  / _` | '_ \ / _ \/ _` |/ _` | |
# | (_| | | | |  __/ (_| | (_| |_|
#  \__,_|_| |_|\___|\__,_|\__,_(_)
                                

Given(/^there is a slack with an access token$/) do
  	@slack_url = "https://slack.com/api/users.list?pretty=1"
  	@valid = Array.new
	@missing = Array.new
	fail "config.yml not found. Please copy from config_example.yml" unless File.exist?('config.yml')
	@config = YAML.load_file('config.yml')
	@token = @config["slack_token"]


end


Given(/^there is a Skype sqlite database$/) do
  @skype_user_db_path = "/Users/"+@config["my_mac_user"]+"/Library/Application\ Support/Skype/"+@config["my_skype_username"]+"/main.db"
  @db = SQLite3::Database::new @skype_user_db_path
  @rows = @db.execute "select * from Contacts"


end

When(/^the slack user list is requested$/) do
  @result = JSON.parse(open(@slack_url + "&token=" + @token).read)
  @result["members"].each do |member|
  	member_skype_name = member["profile"]["skype"]
  	next if member_skype_name.nil?
  	@missing.push member_skype_name
  end

  # haven't had time to figure out why slack has blank skype profile names
  @missing.delete("")

  @total = @missing.length

end

When(/^it is compared to the skype database$/) do

	@rows.each do |row|
		# harsh hack, but works
		if (@missing.include? row[3])
			@missing.delete(row[3])
			@valid.push row[3]
		end

	end
	
  
end

Then(/^the list of slack users versus Skype contacts is returned$/) do
	# should really do something about percentages etc.
	puts "A total of " + @total.to_s + " users were found on Slack."
	puts "You have " + @valid.length.to_s + " added to Skype."
	puts "You are missing " + @missing.length.to_s + " people in Skype."
	puts "Here are the ones you don't have:"
	puts "\t" + @missing.join("\n\t")


end

