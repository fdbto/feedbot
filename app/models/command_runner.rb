class CommandRunner

  def self.run(command)
    url = URI.parse ENV['COMMAND_RUNNER_URL']
    token = ENV['COMMAND_RUNNER_TOKEN']
    base_url = "#{url.scheme}://#{url.host}:#{url.port}"
    f = Faraday.new url: base_url
    response = f.post url.path, { command: command }, { 'X-Command-Runner-Token': token }
  end
end
