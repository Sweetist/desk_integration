require_relative './lib/client'

class DeskEndpoint < EndpointBase::Sinatra::Base

  Honeybadger.configure do |config|
    config.api_key = ENV['HONEYBADGER_KEY']
    config.environment_name = ENV['RACK_ENV']
  end

  post '/create_ticket' do
    begin
      client = Client.new(@config, @payload[:ticket])
      new_case = client.import

      result 200, "New Desk case '#{new_case['subject']}' created, priority: #{new_case['priority']}."
    rescue => e
      log_exception(e)
      result 500, "A Desk.com Endpoint error has ocurred: #{e.message}"
    end

  end
end
