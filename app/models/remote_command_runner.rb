class RemoteCommandRunner

  if ENV['BOT_DISABLED']
    class DummyResponse
      def status; 200; end
      def self.instance
        @instance ||= new
      end
    end
    def self.run(command)
      Rails.logger.debug("RemoteCommandRunner#run:{command:#{command}}")
      { result: {}, response: DummyResponse.instance }
    end
  else
    def self.run(command)
      url = URI.parse ENV['COMMAND_RUNNER_URL']
      token = ENV['COMMAND_RUNNER_TOKEN']
      base_url = "#{url.scheme}://#{url.host}:#{url.port}"
      f = Faraday.new url: base_url
      response = f.post url.path, { command: command }, { 'X-Command-Runner-Token': token }
      { result: JSON.parse(response.body),
        response: response }
    end
  end
end
