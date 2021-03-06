class SlackCommandsController < ApplicationController

  before_filter :slash_command_auth

  WHITELIST_TOKENS = [
    ENV["SLACK_WORK_COMMAND_TOKEN"],
    ENV["SLACK_CARD_COMMAND_TOKEN"],
    ENV["SLACK_RETRO_COMMAND_TOKEN"],
    ENV["SLACK_CHAT_COMMAND_TOKEN"]
  ].compact

  def chat
    append_user_name
    response = SlackTrello::Commands::Work.new(params, ENV["SLACK_WEBHOOK_URL"]).run
    render text: response
  end
  
  def work
    append_user_name
    response = SlackTrello::Commands::Work.new(params, ENV["SLACK_WEBHOOK_URL"]).run
    render text: response
  end
  
  def create_card
    
    puts params.inspect
    # prefix: "Sensei"
    # e.g: /card (general today) what is new
    # /work (list_name)##(content)
    unless /\#\w+/ =~ params[:text]
      render text: 'Please specify List with \'#\', i.e: #Good My smartwatch is really Awesome!!'
    else
      params[:text] = "(" + prefix + overwrite_channel_if_board_name_exists + " " + params[:text].split[0].strip[1..-1] + ")" +  params[:text][params[:text].split[0].length..-1] + " - "  + params[:user_name] + ""
      #puts params[:text].inspect
      response = SlackTrello::Commands::CreateCard.new(params, ENV["SLACK_WEBHOOK_URL"]).run
      render text: response
    end

  end

  def card
    append_user_name
    response = SlackTrello::Commands::CreateCard.new(params, ENV["SLACK_WEBHOOK_URL"]).run
    render text: response
  end

  def retro
    response = SlackTrello::Commands::Retro.new(params, ENV["SLACK_WEBHOOK_URL"]).run
    render text: response
  end

  def copy_cards
    response = SlackTrello::Commands::CopyCards.new(params, ENV["SLACK_WEBHOOK_URL"]).run
    render text: response
  end

  private

  def slash_command_auth
    # puts '+++ Hi Sensei ++tokens++' + WHITELIST_TOKENS.inspect
    unless WHITELIST_TOKENS.include?(params[:token])
      render text: "Unauthorized", status: :unauthorized
    end
  end
  
  def append_user_name
    # merge username into the topic
    params[:text] += " - " + params[:user_name] 
  end
  
  def prefix
    @prefix = ''
    @prefix = params[:prefix] + '_' if params[:prefix]
    @prefix
  end

  def overwrite_channel_if_board_name_exists
    @channel_name = params[:channel_name]
    @channel_name = params[:board] if params[:board]
    @channel_name
  end
end

