# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

# Configures the endpoint
config :people_sorter, PeopleSorterWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "wQvlYrp/jNWzOeiezLe4kjBWxU4QrtufwGpBV8mCQY5Bfj9OT7Hzamn5R9c0GJOz",
  render_errors: [view: PeopleSorterWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: PeopleSorter.PubSub,
  live_view: [signing_salt: "HSufgrzy"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
