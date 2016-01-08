Rails.application.routes.draw do
  post "/slack/chat", :to => "slack_commands#chat"
  post "/slack/work", :to => "slack_commands#work"
  post "/slack/retro", :to => "slack_commands#retro"
  post "/slack/card", :to => "slack_commands#create_card"
  post "/slack/copy_cards", :to => "slack_commands#copy_cards"
  
  get 'health'
end
