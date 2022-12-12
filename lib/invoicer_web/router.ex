defmodule InvoicerWeb.Router do
  use InvoicerWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {InvoicerWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", InvoicerWeb do
    pipe_through :browser

    live "/", Pages.HomeLive
  end

  scope "/settings", InvoicerWeb do
    pipe_through :browser

    live "/", Pages.SettingsLive

    live "/uoms", UomLive.Index, :index
    live "/uoms/new", UomLive.Index, :new
    live "/uoms/:id/edit", UomLive.Index, :edit

    live "/uoms/:id", UomLive.Show, :show
    live "/uoms/:id/show/edit", UomLive.Show, :edit

    live "/taxes", TaxLive.Index, :index
    live "/taxes/new", TaxLive.Index, :new
    live "/taxes/:id/edit", TaxLive.Index, :edit

    live "/taxes/:id", TaxLive.Show, :show
    live "/taxes/:id/show/edit", TaxLive.Show, :edit

    live "/rates", RateLive.Index, :index
    live "/rates/new", RateLive.Index, :new
    live "/rates/:id/edit", RateLive.Index, :edit

    live "/rates/:id", RateLive.Show, :show
    live "/rates/:id/show/edit", RateLive.Show, :edit

    live "/currencies", CurrencyLive.Index, :index
    live "/currencies/new", CurrencyLive.Index, :new
    live "/currencies/:id/edit", CurrencyLive.Index, :edit

    live "/currencies/:id", CurrencyLive.Show, :show
    live "/currencies/:id/show/edit", CurrencyLive.Show, :edit

    live "/currencies/:id/rates", CurrencyRatesLive
  end

  # Other scopes may use custom stacks.
  # scope "/api", InvoicerWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:invoicer, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: InvoicerWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
