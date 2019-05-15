require 'rails_helper'

feature 'sign in with any email address' do
  scenario 'signing in with any email address' do
    allow(FeatureManagement).to receive(:prefill_otp_codes?).and_return(true)

    user = create(:user, :signed_up, :with_multiple_emails)

    email1, email2 = user.reload.email_addresses.map(&:email)

    signin(email1, user.password)
    click_submit_default

    expect(page).to have_current_path(account_path)

    first(:link, t('links.sign_out')).click

    signin(email2, user.password)
    click_submit_default

    expect(page).to have_current_path(account_path)
  end

  scenario 'signing in with an unconfirmed email results in an error' do
    user = create(:user, :signed_up, :with_multiple_emails)

    email_address = user.email_addresses.first
    email_address.update!(confirmed_at: nil)

    signin(email_address.email, user.password)

    error_message = t('devise.failure.invalid_html', link: t('devise.failure.invalid_link_text'))

    expect(page).to have_content(error_message)
    expect(page).to have_current_path(new_user_session_path)
  end
end
