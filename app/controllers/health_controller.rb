class HealthController <  ActionController::Base
  def index
    puts 'HELLO 2'
    @text_to_check = 'Slack-Responder-OK'
    @timestamp = Time.now
  end
end
