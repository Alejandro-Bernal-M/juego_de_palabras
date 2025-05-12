require 'httparty'

class AnalyzeWordService
  def initialize(word)
    @word = word
    @api_key = Rails.application.credentials.dig(:words_api, :api_key)
    @host = 'wordsapiv1.p.rapidapi.com'
    @url = "https://#{@host}/words/#{@word}/synonyms"
  end

  def call
    headers = {
      "X-RapidAPI-Key" => @api_key,
      "X-RapidAPI-Host" => @host
    }

    message_response = {}

    begin
      response = HTTParty.get(@url, headers: headers)
      if response.success?
        content = response.parsed_response["synonyms"]

        if content.empty? || content.size < 3 || content.is_a?(String)
          message_response = {
            status: 'error',
            content: "Not enough synonyms found for the word '#{@word}'."
          }
        else
          message_response = {
            status: 'ok',
            content: content.first(3)
          }
        end

      else
        message_response = {
          status: 'error',
          content: response.parsed_response["message"]
        }
      end
    rescue => e
      message_response = {
        status: 'error',
        content: e.message
      }
    end

    message_response
  end
end
