module Registration
  class AccountSecurityForm
    include ActiveModel::Model
    include ActiveModel::Attributes

    attribute :app_authentication
    attribute :app_authentication_code
    attribute :secret_key
    attribute :full_name
    attribute :mobile_number
    attribute :password
    attribute :secondary_authentication_methods
    attribute :sms_authentication
    attribute :user

    validates_presence_of :full_name, if: :name_required?

    validates :password, length: { minimum: 8 }, if: -> { password.present? }
    validates :password, presence: true
    validate :secondary_authentication_methods_presence

    with_options if: :app_authentication_selected? do
      validates :app_authentication_code, presence: true
      validate :app_authentication_code, :validate_app_authentication_code
    end

    with_options if: :sms_authentication_selected? do
      validates :mobile_number, presence: { message: :invalid }
      validates :mobile_number,
                phone: { message: :invalid, allow_international: true },
                if: :validate_international_mobile_number?
      validates :mobile_number,
                phone: { message: :invalid, allow_international: false },
                if: :validate_uk_mobile_number?
    end

    delegate :qr_code, to: :secondary_authentication

    def update!
      return false unless valid?

      user.update!(
        mobile_number: mobile_number,
        password: password,
        name: full_name,
        account_security_completed: true,
        confirmation_token: nil,
        confirmation_sent_at: nil,
        confirmed_at: Time.zone.now,
        last_totp_at: secondary_authentication.last_totp_at,
        totp_secret_key: (secret_key if app_authentication_selected?),
        secondary_authentication_methods: secondary_authentication_methods,
      )
    end

    def [](field)
      public_send(field.to_sym)
    end

    def full_name
      name_required? ? super : user.name
    end

    def name_required?
      user.is_a?(SearchUser) || user.name.blank?
    end

    # Generates a new key only if key is not coming from the form submission.
    # Keeping the same key between failed form submissions is important as
    # allows to keep the same QR code between attempts.
    # If not the user would need to re-add the QR code into their authenticator
    # app with each failed submission attempt.
    def secret_key
      @secret_key ||= (super || SecondaryAuthentication::TimeOtp.generate_secret_key)
    end

    def decorated_secret_key
      # Groups of 4 characters followed by a space
      secret_key.gsub(/(.{4})/, '\1 ').strip
    end

    def sms_authentication_selected?
      sms_authentication == "1"
    end

    def app_authentication_selected?
      app_authentication == "1"
    end

    # Following methods override attrs to discard them unless the authentication
    # method they depend on is selected.
    # EG: If the SMS is not selected on form submission, we discard the mobile
    # number value.

    def app_authentication_code
      app_authentication_selected? ? super : nil
    end

    def mobile_number
      sms_authentication_selected? ? super : nil
    end

  private

    def secondary_authentication
      @secondary_authentication ||= SecondaryAuthentication::TimeOtp.new(user, secret_key)
    end

    def secondary_authentication_methods
      [].tap do |methods|
        methods << "app" if app_authentication_selected?
        methods << "sms" if sms_authentication_selected?
      end
    end

    def validate_app_authentication_code
      return if app_authentication_code.blank?

      unless secondary_authentication.valid_otp?(app_authentication_code)
        errors.add(:app_authentication_code, :invalid)
      end
    end

    def secondary_authentication_methods_presence
      if secondary_authentication_methods.none?
        errors.add(:secondary_authentication_methods, :blank)
      end
    end

    def validate_uk_mobile_number?
      mobile_number.present? && user && !user.class::ALLOW_INTERNATIONAL_PHONE_NUMBER
    end

    def validate_international_mobile_number?
      mobile_number.present? && user && user.class::ALLOW_INTERNATIONAL_PHONE_NUMBER
    end
  end
end
