class ApplicationController < ActionController::API

  include ActionController::HttpAuthentication::Basic::ControllerMethods

  before_action :authenticate, except: :not_found

  def not_found
    head 405
  end

  private

  # Authenticate account
  def authenticate
    authenticate_or_request_with_http_basic do |user, password|
      account = Account.find_by(username: user)
      if account.present?
        unless account.auth_id.eql?(password)
          head 403
        end
        true # If valid account and credentials proceed
      else
        head 403
      end
    end
  end


end
