class Webhooks::Incoming::WebhooksController < ApplicationController
  skip_before_action :verify_authenticity_token
  layout false
end
