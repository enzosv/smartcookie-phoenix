# lib/smartcookie_web/router.ex
defmodule SmartcookieWeb.Router do
  use SmartcookieWeb, :router

  import SmartcookieWeb.UserAuth

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {SmartcookieWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :fetch_current_user
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  # Public routes
  scope "/", SmartcookieWeb do
    pipe_through :browser

    get "/", PageController, :home
  end

  # User authentication routes
  scope "/", SmartcookieWeb do
    pipe_through [:browser, :redirect_if_user_is_authenticated]

    live_session :redirect_if_user_is_authenticated,
      on_mount: [{SmartcookieWeb.UserAuth, :redirect_if_user_is_authenticated}] do
      live "/users/register", UserRegistrationLive, :new
      live "/users/log_in", UserLoginLive, :new
      live "/users/reset_password", UserForgotPasswordLive, :new
      live "/users/reset_password/:token", UserResetPasswordLive, :edit
    end

    post "/users/log_in", UserSessionController, :create
  end

  # Protected routes (require authentication)
  scope "/", SmartcookieWeb do
    # pipe_through [:browser, :require_authenticated_user]
    pipe_through [:browser]

    # live_session :require_authenticated_user,
    #   on_mount: [{SmartcookieWeb.UserAuth, :ensure_authenticated}] do
    #   live "/users/settings", UserSettingsLive, :edit
    #   live "/users/settings/confirm_email/:token", UserSettingsLive, :confirm_email
    # end

    # Dashboard routes
    get "/dashboard", DashboardController, :index

    # Quiz routes
    get "/quiz", QuestionController, :quiz
    post "/submit", QuestionController, :submit
    get "/attempt/:id", QuestionController, :attempt
  end

  scope "/", SmartcookieWeb do
    pipe_through [:browser]

    delete "/users/log_out", UserSessionController, :delete

    live_session :current_user,
      on_mount: [{SmartcookieWeb.UserAuth, :mount_current_user}] do
      live "/users/confirm/:token", UserConfirmationLive, :edit
      live "/users/confirm", UserConfirmationInstructionsLive, :new
    end
  end
end
