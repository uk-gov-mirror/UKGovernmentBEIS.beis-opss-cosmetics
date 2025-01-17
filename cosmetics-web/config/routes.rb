require "constraints/domain_inclusion_constraint"
require "constraints/domain_exclusion_constraint"
require "sidekiq/web"
require "sidekiq/cron/web"

if Rails.env.production?
  Sidekiq::Web.use Rack::Auth::Basic do |username, password|
    ActiveSupport::SecurityUtils.secure_compare(username, ENV["SIDEKIQ_USERNAME"]) &&
      ActiveSupport::SecurityUtils.secure_compare(password, ENV["SIDEKIQ_PASSWORD"])
  end
end
Rails.application.routes.draw do
  mount GovukDesignSystem::Engine => "/", as: "govuk_design_system_engine"

  get "/sign_up", to: redirect("/")
  resource :password_changed, controller: "users/password_changed", only: :show, path: "password-changed"

  scope module: "secondary_authentication", path: "two-factor" do
    get "method", to: "method#new", as: :new_secondary_authentication_method
    post "method", to: "method#create", as: :secondary_authentication_method

    get "sms", to: "sms#new", as: :new_secondary_authentication_sms
    post "sms", to: "sms#create", as: :secondary_authentication_sms

    get "app", to: "app#new", as: :new_secondary_authentication_app
    post "app", to: "app#create", as: :secondary_authentication_app

    scope module: "sms", path: "sms" do
      get "not-received", to: "resend#new", as: :new_secondary_authentication_sms_resend
      post "not-received", to: "resend#create", as: :secondary_authentication_sms_resend
    end
  end

  unless Rails.env.production? && (!ENV["SIDEKIQ_USERNAME"] || !ENV["SIDEKIQ_PASSWORD"])
    mount Sidekiq::Web => "/sidekiq"
  end

  constraints DomainInclusionConstraint.new(ENV.fetch("SEARCH_HOST")) do
    devise_for :search_users,
               path: "",
               path_names: { sign_up: "sign-up", sign_in: "sign-in", sign_out: "sign-out" },
               controllers: { passwords: "users/passwords", registrations: "users/registrations", sessions: "users/sessions", unlocks: "users/unlocks" }
    devise_scope :search_user do
      resource :check_your_email, path: "check-your-email", only: :show, controller: "users/check_your_email"
      post "sign-out-before-resetting-password", to: "users/passwords#sign_out_before_resetting_password"
      post "sign-out-before-confirming-email", to: "users/confirmations#sign_out_before_confirming_email"
    end
    root "search/landing_page#index"

    scope module: "poison_centres", as: "poison_centre" do
      resources :notifications, param: :reference_number, only: %i[index show]
    end
    resources :users, only: [:update] do
      member do
        get "complete-registration", action: :complete_registration
        post "sign-out-before-accepting-invitation", action: :sign_out_before_accepting_invitation
      end
    end

    resource :dashboard, controller: "search/dashboard", only: %i[show]
  end

  # All requests besides "Search" host ones will default to "Submit" pages.
  constraints DomainExclusionConstraint.new(ENV.fetch("SEARCH_HOST")) do
    devise_for :submit_users,
               path: "",
               path_names: { sign_in: "sign-in", sign_out: "sign-out" },
               controllers: { confirmations: "users/confirmations", passwords: "users/passwords", sessions: "users/sessions", unlocks: "users/unlocks" },
               skip: %i[confirmation registration]
    devise_scope :submit_user do
      resource :check_your_email, path: "check-your-email", only: :show, controller: "users/check_your_email"
      post "sign-out-before-resetting-password", to: "users/passwords#sign_out_before_resetting_password"
    end

    get "create-an-account", to: "registration/new_accounts#new", as: :registration_new_submit_user
    post "create-an-account", to: "registration/new_accounts#create", as: :registration_create_submit_user
    get "confirm-new-account", to: "registration/new_accounts#confirm", as: :registration_confirm_submit_user
    get "account-security", to: "registration/account_security#new", as: :registration_new_account_security
    post "account-security", to: "registration/account_security#create", as: :registration_create_account_security
    post "sign-out-before-confirming-email", to: "registration/new_accounts#sign_out_before_confirming_email"

    root "submit/landing_page#index"

    resources :responsible_persons do
      collection do
        resources :account, controller: "responsible_persons/account_wizard", only: %i[show update]
        get "select", to: "responsible_persons#select"
      end

      member do
        get "change", to: "responsible_persons#change"
      end

      resources :nanomaterials, controller: :nanomaterial_notifications, only: %i[index new create], shallow: true do
        member do
          get :name
          patch :name, action: "update_name"
          get :notified_to_eu
          patch :notified_to_eu, action: "update_notified_to_eu"
          get :upload_file
          patch :file, action: "update_file"
          get :review
          patch :submission, action: "submit"
          get :confirmation, action: "confirmation_page"
        end
      end

      resources :contact_persons, controller: "responsible_persons/contact_persons", only: %i[new create edit update] do
      end

      resources :team_members, controller: "responsible_persons/team_members", only: %i[index new create] do
        member do
          get "new-account", action: :new_account
          get "resend-invitation", action: :resend_invitation
        end
        collection do
          get :join
          post "sign-out-before-joining", action: :sign_out_before_joining
        end
      end

      resources :add_notification, controller: "responsible_persons/wizard/add_notification_wizard", only: %i[show new update]

      resources :notification_files, controller: "responsible_persons/notification_files", only: %i[show new create destroy] do
        collection do
          delete :destroy_all
        end
      end

      resources :notifications, param: :reference_number, controller: "responsible_persons/notifications", only: %i[index show new edit] do
        resources :build, controller: "responsible_persons/wizard/notification_build", only: %i[show update new]
        resources :additional_information, controller: "responsible_persons/additional_information", only: %i[index]
        resources :product_image_upload, controller: "responsible_persons/product_image_upload", only: %i[new create]

        resources :components do
          resources :build, controller: "responsible_persons/wizard/component_build", only: %i[show update new]
          resources :trigger_question, controller: "responsible_persons/wizard/trigger_questions", only: %i[show update new]
          resources :formulation, controller: "responsible_persons/formulation_upload", only: %w[new create]
          resources :nanomaterials, param: :nano_element_id do
            resources :build, controller: "responsible_persons/wizard/nanomaterial_build", only: %i[show update new]
          end
        end

        member do
          post :confirm
        end
      end

      resources :delete_notification, param: :reference_number, controller: "responsible_persons/delete_notification", only: [] do
        member do
          get :delete
          delete :destroy
        end
      end
    end
    resource :dashboard, controller: "submit/dashboard", only: %i[show]
  end

  resource :my_account, only: [:show], controller: :my_account do
    scope module: :my_account do
      resource :password, controller: :password, only: %i[edit update]
      resource :name, controller: :name, only: %i[edit update]
      resource :mobile_number, controller: :mobile_number, only: %i[edit update]
      resource :email, controller: :email, only: %i[edit update] do
        member do
          get :confirm
        end
      end
    end
  end

  resource :declaration, controller: :declaration, only: %i[show] do
    post :accept
  end

  namespace :guidance, as: "" do
    get :how_to_notify_nanomaterials, path: "how-to-notify-nanomaterials"
    get :how_to_prepare_images_for_notification, path: "how-to-prepare-images-for-notification"
    get :how_to_set_up_authenticator_app, path: "how-to-set-up-authenticator-app"
  end

  namespace :help, as: "" do
    get :accessibility_statement, path: "accessibility-statement"
    get :terms_and_conditions, path: "terms-and-conditions"
    get :privacy_notice, path: "privacy-notice"
  end

  get "frame_formulations", to: "frame_formulations#index"
  get "frame_formulations/:id/:sub_id/:name", to: "frame_formulations#show"

  get "invalid-account", to: "errors#invalid_account", as: :invalid_account

  match "/404", to: "errors#not_found", via: :all
  match "/403", to: "errors#forbidden", via: :all
  match "/500", to: "errors#internal_server_error", via: :all
  match "/503", to: "errors#timeout", via: :all
end
