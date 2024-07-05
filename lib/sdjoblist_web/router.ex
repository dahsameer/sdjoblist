defmodule SdjoblistWeb.Router do
  use SdjoblistWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :rootlayout do
    plug :put_root_layout, html: {SdjoblistWeb.Layouts, :root}
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", SdjoblistWeb do
    pipe_through :browser
    pipe_through :rootlayout

    get "/", PageController, :home
    get "/status", PageController, :status
    get "/contact", PageController, :contact
  end

  scope "/", SdjoblistWeb do
    pipe_through :browser
    get "/scroll", PageController, :scroll
  end

  # Other scopes may use custom stacks.
  # scope "/api", SdjoblistWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:sdjoblist, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: SdjoblistWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
