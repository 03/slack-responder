class SlackCommandsController < ApplicationController

  before_filter :slash_command_auth

  WHITELIST_TOKENS = [
    ENV["SLACK_WORK_COMMAND_TOKEN"],
    ENV["SLACK_CARD_COMMAND_TOKEN"],
    ENV["SLACK_RETRO_COMMAND_TOKEN"]
  ].compact

  def work
    response = SlackTrello::Commands::Work.new(params, ENV["SLACK_WEBHOOK_URL"]).run
    render text: response
  end

  def create_card
    response = SlackTrello::Commands::CreateCard.new(params, ENV["SLACK_WEBHOOK_URL"]).run
    render text: response
  end

  def retro
    puts "IN Retro"
    puts SlackTrello::Commands::Retro.inspect
    response = SlackTrello::Commands::Retro.new(params, ENV["SLACK_WEBHOOK_URL"]).run
    render text: response
  end

  def copy_cards
    response = SlackTrello::Commands::CopyCards.new(params, ENV["SLACK_WEBHOOK_URL"]).run
    render text: response
  end

  private

  def slash_command_auth
    puts 'HiHi'
    puts WHITELIST_TOKENS.inspect
    unless WHITELIST_TOKENS.include?(params[:token])
      render text: "Unauthorized", status: :unauthorized
    end
  end

end

