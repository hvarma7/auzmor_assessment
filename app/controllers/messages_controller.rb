class MessagesController < ApplicationController

  before_action :check_required_parameters, :validate_parameters

  def inbound
    phone_number = PhoneNumber.find_by(number: params[:to])
    if phone_number.blank?
      render json: { message: '', error: "to parameter not found" }, status: 422
    else
      # match?(/STOP|STOP\n|STOP\r|STOP\r\n/) ???regex perhaps to detect the string
      if %w[STOP STOP/n STOP/n/r].include?(message_params[:text].to_s)
        Cache.set(message_params[:to].to_s + '_' + message_params[:from].to_s, 0, 14400)
      end
      render json: { message: 'inbound sms ok', error: '' }, status: 422
    end
  end

  def outbound
    cache_key = message_params[:to].to_s + '_' + message_params[:from].to_s
    data = Cache.get(cache_key)
    if data.present?
      if data <= 50
        Cache.increment(cache_key)
        Cache.update_ttl(cache_key) # Update to default 24 hours ttl
        render json: { message: "", error: "sms from #{message_params[:from]} to #{message_params[:to]} blocked by STOP request" }, status: 422
      else
        render json: { message: "", error: "limit reached for from #{message_params[:from]}" }, status: 422
      end
    else
      phone_number = PhoneNumber.find_by(number: params[:from])
      if phone_number.blank?
        render json: { message: '', error: "from parameter not found" }, status: 422
      else
        render json: { message: "outbound sms ok", error: "" }, status: 200
      end
    end
  end

  private

  def message_params
    params.permit([:from, :to, :text])
  end

  # Check if the payload has all required params
  def check_required_parameters
    required_param = nil
    if message_params[:from].blank?
      required_param = 'from'
    elsif message_params[:to].blank?
      required_param = 'to'
    elsif message_params[:text].blank?
      required_param = 'text'
    end
    render json: { message: '', error: "#{required_param} is missing" }, status: 422 unless required_param.nil?
  end

  # Validate the payload length
  def validate_parameters
    invalid_param = nil
    if !message_params[:from].length.between?(6, 16)
      invalid_param = 'from'
    elsif !message_params[:to].length.between?(6, 16)
      invalid_param = 'to'
    elsif !message_params[:text].length.between?(1, 150)
      invalid_param = 'text'
    end
    render json: { message: '', error: "#{invalid_param} is invalid" }, status: 422 unless invalid_param.nil?
  end

end