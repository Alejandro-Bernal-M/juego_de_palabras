class HomeController < ApplicationController
  def index; end

  def search_word
    @word = params[:word]

    if @word.blank?
      flash.now[:alert] = "Please enter a word to search."

      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: turbo_stream.replace(
            "flash_messages",
            partial: "/layouts/flash_messages",
            locals: { flash: flash }
          )
        end
      end
      return
    end

    @response = AnalyzeWordService.new(@word).call
    
    if @response[:status] == 'ok'
      flash.now[:notice] = "Synonyms found"
    else
      flash.now[:alert] = @response[:content]
    end

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: [
          turbo_stream.replace("flash_messages", partial: "/layouts/flash_messages", locals: { flash: flash }),
          turbo_stream.replace("synonyms", partial: "home/synonyms", locals: { synonyms: @response[:content] }),
        ]
      end
    end
  end
end
