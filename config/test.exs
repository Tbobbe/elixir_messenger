import Config

# Only in tests, remove the complexity from the password hashing algorithm
config :bcrypt_elixir, :log_rounds, 1

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :elixir_messenger, ElixirMessenger.Repo,
  username: System.get_env("POSTGRESQL_USERNAME") || "postgres",
  password: System.get_env("POSTGRESQL_PASSWORD") || "postgres",
  hostname: System.get_env("HOST") || "localhost",
  database: "elixir_messenger_test#{System.get_env("MIX_TEST_PARTITION")}",
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: 10

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :elixir_messenger, ElixirMessengerWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "+xXUPeAI5LHegjgMl9tXhROC0PQJF41ceaqYFmo/Yz/Yu5/7/wkZ7P7WW9jJ95aN",
  server: false

# In test we don't send emails.
config :elixir_messenger, ElixirMessenger.Mailer, adapter: Swoosh.Adapters.Test

# Print only warnings and errors during test
config :logger, level: :warn

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime
