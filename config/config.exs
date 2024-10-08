# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :sdjoblist,
  ecto_repos: [Sdjoblist.Repo],
  generators: [timestamp_type: :utc_datetime]

# Configures the endpoint
config :sdjoblist, SdjoblistWeb.Endpoint,
  url: [host: "localhost"],
  adapter: Bandit.PhoenixAdapter,
  render_errors: [
    formats: [html: SdjoblistWeb.ErrorHTML, json: SdjoblistWeb.ErrorJSON],
    layout: false
  ],
  pubsub_server: Sdjoblist.PubSub,
  live_view: [signing_salt: "FbMqVMaN"]

# Configures the mailer
#
# By default it uses the "Local" adapter which stores the emails
# locally. You can see the emails in your browser, at "/dev/mailbox".
#
# For production it's recommended to configure a different adapter
# at the `config/runtime.exs`.
config :sdjoblist, Sdjoblist.Mailer, adapter: Swoosh.Adapters.Local

# Configure esbuild (the version is required)
config :esbuild,
  version: "0.17.11",
  sdjoblist: [
    args:
      ~w(js/app.js js/home.js --bundle --target=es2017 --outdir=../priv/static/assets --external:/fonts/* --external:/images/*),
    cd: Path.expand("../assets", __DIR__),
    env: %{"NODE_PATH" => Path.expand("../deps", __DIR__)}
  ]

# Configure tailwind (the version is required)
config :tailwind,
  version: "3.4.0",
  sdjoblist: [
    args: ~w(
      --config=tailwind.config.js
      --input=css/app.css
      --output=../priv/static/assets/app.css
    ),
    cd: Path.expand("../assets", __DIR__)
  ]

# Configures Elixir's Logger
config :logger, :console,
  format: "[$date] [$time] $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :crawly,
    closespider_timeout: 10,
    concurrent_requests_per_domain: 8,
    closespider_itemcount: 100,

    middlewares: [
            Crawly.Middlewares.DomainFilter,
            Crawly.Middlewares.UniqueRequest,
            {Crawly.Middlewares.UserAgent, user_agents: ["Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:105.0) Gecko/20100101 Firefox/105.0"]}
    ],
    pipelines: [
            {Crawly.Pipelines.Validate, fields: [:url, :title, :price]},
            {Crawly.Pipelines.DuplicatesFilter, item_id: :title},
            {Crawly.Pipelines.JSONEncoder}
    ]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
