defmodule PeopleSorterWeb.Router do
  use PeopleSorterWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {PeopleSorterWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]

    get "/records/birthdate", PeopleSorterWeb.RecordController, :dob
    get "/records/color", PeopleSorterWeb.RecordController, :color
    get "/records/last_name", PeopleSorterWeb.RecordController, :last_name

    resources "/records", PeopleSorterWeb.RecordController,
      except: [:new, :update, :delete, :edit]
  end

  scope "/", PeopleSorterWeb do
    pipe_through :browser

    live "/", PageLive, :index
  end

  # Other scopes may use custom stacks.
  # scope "/api", PeopleSorterWeb do
  #   pipe_through :api
  # end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through :browser
      live_dashboard "/dashboard", metrics: PeopleSorterWeb.Telemetry
    end
  end
end
