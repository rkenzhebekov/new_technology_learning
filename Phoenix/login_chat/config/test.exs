use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :login_chat, LoginChatWeb.Endpoint,
  http: [port: 4002],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :login_chat, LoginChat.Repo,
  username: "postgres",
  password: "postgres",
  database: "login_chat_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox
