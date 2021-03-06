

module Slack
  class SlackError < StandardError; end

  class Recipient
    attr_reader :slack_id, :name

    def initialize(slack_id, name)
      @slack_id = slack_id
      @name = name
    end

    def send_message(message, token: ENV["SLACK_API_TOKEN"])
      response = HTTParty.post(
        "https://slack.com/api/chat.postMessage",
        headers: {"Content-Type" => "application/x-www-form-urlencoded"},
        body: {
          token: token,
          channel: self.slack_id,
          text: message,
        },
      )

      if response.code == 200 && response["ok"]
        return true
      else
        raise Slack::SlackError, "Error: #{response.parsed_response["error"]}"
      end
    end

    def self.get(url, token: ENV["SLACK_API_TOKEN"])
      response = HTTParty.get(
        url,
        query: {
          token: token,
        },
      )

      if response.code == 200 && response["ok"]
        return response.parsed_response
      else
        raise Slack::SlackError, "Error: #{response.code} #{response.message}"
      end

      # return response.parsed_response
    end

    def self.list
      raise NotImplementedError, "Implement me in a child class!"
    end

    def details
      raise NotImplementedError, "Implement me in a child class!"
    end
  end
end
