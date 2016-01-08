class HealthController <  ActionController::Base
  def index
    render text: Time.now.inspect + ' --> Slack-Responder-OK'
  end
end
