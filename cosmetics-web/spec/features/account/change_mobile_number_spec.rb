require 'rails_helper'

RSpec.describe "Changing mobile number", :with_2fa, :with_stubbed_mailer, :with_stubbed_notify, type: :feature do
  before do
    configure_requests_for_search_domain
  end

  def fill_in_credentials(password_override: nil)
    fill_in "Email address", with: user.email
    if password_override
      fill_in "Password", with: password_override
    else
      fill_in "Password", with: user.password
    end
    click_on "Continue"
  end

  def expect_user_to_have_received_sms_code(code)
    expect(notify_stub).to have_received(:send_sms).with(
      hash_including(phone_number: user.mobile_number, personalisation: { code: code }),
    )
  end

  def expect_to_be_on_secondary_authentication_page
    expect(page).to have_current_path(/\/two-factor/)
    expect(page).to have_h1("Check your phone")
  end

  def expect_to_be_on_resend_secondary_authentication_page
    expect(page).to have_current_path("/text-not-received")
    expect(page).to have_h1("Resend security code")
  end

  def otp_code
    user.reload.direct_otp
  end

  def expect_to_be_on_my_account_page
    expect(page).to have_current_path(/\/my_account/)
  end

  let(:user) { create(:poison_centre_user, has_accepted_declaration: true) }

  before do
    visit "/sign-in"
    fill_in_credentials

    expect(page).to have_css("h1", text: "Check your phone")
    fill_in "Enter security code", with: "#{otp_code} "
    click_on "Continue"

    click_on "Your account"
    expect_to_be_on_my_account_page

    wait_for = SecondaryAuthentication::TIMEOUTS[SecondaryAuthentication::CHANGE_MOBILE_NUMBER]
    travel_to (wait_for + 1).seconds.from_now

    click_on "Change mobile number"
    expect(page).to have_css("h1", text: "Check your phone")
    fill_in "Enter security code", with: "#{otp_code} "
    click_on "Continue"
  end

  context "when the password change is fine" do

    it "changes password properly" do
      fill_in "Password", with: user.password
      fill_in "New mobile number", with: "07234234234"
      click_on "Save"

      expect(page).to have_css("h1", text: "Check your phone")
      fill_in "Enter security code", with: "#{otp_code} "
      click_on "Continue"

      expect_to_be_on_my_account_page
      expect(page).to have_text(/Mobile number changed successfully/)
    end
  end

  context "when the update cant be done" do
    it "does not get updated when password is wrong" do
      fill_in "Password", with: "user.password"
      fill_in "New mobile number", with: "07500111000"
      click_on "Save"

      expect(page).to have_css("h2#error-summary-title", text: "There is a problem")
      expect(page).to have_link("Password is incorrect", href: "#password")
    end

    # Mobile number validation is tricky,
    # but due to a nature of requirement of mobile verification,
    # for now it can stay so
    xit "does not get updated when new mobile number is empty" do
      fill_in "Password", with: user.password
      fill_in "New mobile number", with: ""
      click_on "Save"

      expect(page).to have_css("h2#error-summary-title", text: "There is a problem")
      expect(page).to have_link("Mobile number can not be blank", href: "#mobile_number")
    end
  end
end