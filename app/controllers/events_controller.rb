class EventsController < ApplicationController
  before_action :confirm_two_factor_authenticated

  layout 'card_wide'

  def show
    analytics.track_event(Analytics::ACCOUNT_VISIT)
    @view_model = AccountShow.new(
      decrypted_pii: nil,
      personal_key: nil,
      decorated_user: current_user.decorate,
    )
    device_and_events
    render 'accounts/events/show'
  end

  private

  def device_and_events
    id = params[:id]
    @events = DeviceTracking::ListDeviceEvents.call(current_user, id).map(&:decorate)
    @device = Device.where(id: id.to_i).first
  end
end