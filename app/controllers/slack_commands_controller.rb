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
    
    # prefix: "Sensei"
    # e.g: /card (general today) what is new
    # /work (list_name)##(content)
    prefix = ''
    prefix = params[:prefix] + '_' if params[:prefix]
    params[:text] = "(" + prefix +params[:channel_name] + " " + params[:text].split[0].strip[1..-1] + ")" +  params[:text][params[:text].split[0].length+1..-1].split.join('_').strip + " - "  + params[:user_name] + ""
    puts '+++++++++++++++++++'
    puts params[:text].inspect
    render text: 'test'
    #response = SlackTrello::Commands::Work.new(params, ENV["SLACK_WEBHOOK_URL"]).run
    #response = SlackTrello::Commands::CreateCard.new(params, ENV["SLACK_WEBHOOK_URL"]).run
    #render text: response
  end

  def create_card
    append_user_name
    response = SlackTrello::Commands::CreateCard.new(params, ENV["SLACK_WEBHOOK_URL"]).run
    render text: response
  end

  def retro
    #puts "IN Retro"
    #puts params.inspect
    #    begin
    #  tr = SlackTrello::Commands::Retro.new(params, ENV["SLACK_WEBHOOK_URL"])
    #  puts tr.inspect
    #  response = tr.run
    #rescue Exception => e  
    #puts e.inspect
     # puts "There was an error: #{e.message}"
    #end
    
    response = SlackTrello::Commands::Retro.new(params, ENV["SLACK_WEBHOOK_URL"]).run
    render text: response
  end

  def copy_cards
    response = SlackTrello::Commands::CopyCards.new(params, ENV["SLACK_WEBHOOK_URL"]).run
    render text: response
  end

  private

  def slash_command_auth
    puts 'Hi Sensei'
    # puts WHITELIST_TOKENS.inspect
    unless WHITELIST_TOKENS.include?(params[:token])
      render text: "Unauthorized", status: :unauthorized
    end
  end
  
  def append_user_name
    # merge username into the topic
    # params[:text] += " <i> " + params[:user_name] + "</i>"
  end

end

