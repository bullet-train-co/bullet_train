class Webhooks::Incoming::BulletTrainWebhooksController < Webhooks::Incoming::WebhooksController
  def create
    Webhooks::Incoming::BulletTrainWebhook.create(data: JSON.parse(request.body.read)).process_async
    render json: {status: "OK"}, status: :created
  end
end
