require 'rest-client'
require 'json'
require 'htmlentities'

class TubeStatus
  include Cinch::Plugin

  match /tube/
  match /tube (\w+)/

  DEFAULT_STATIONS = 'central,circle,hammersmithcity,victoria'

  def execute(m, stations=DEFAULT_STATIONS)
    url = "http://api.tubeupdates.com/?method=get.status&lines=#{stations}"
    response = JSON.parse(RestClient.get url)
    parsed = response['response']
    if response['response']['lines']
      response['response']['lines'].each do |line|
        status = "#{line['name']} - #{line['status']}\n"
        m.reply HTMLEntities.new.decode(status)
      end
    elsif response['response']['error']
      m.reply "Error: #{response['response']['error']}"
    else
      m.reply 'Epic tube fail'
    end
  end
end
