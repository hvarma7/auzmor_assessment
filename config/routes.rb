Rails.application.routes.draw do

  root to: "application#not_found"

  scope 'api' do
    post '/inbound/sms/' => 'messages#inbound'
    post '/outbound/sms/' => 'messages#outbound'
  end

  match '*unmatched', to: 'application#not_found', via: :all
end
