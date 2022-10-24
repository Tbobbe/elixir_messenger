# ElixirMessenger

Elixir Messenger: A simple messaging application I built just for experience and fun.

# Prerequisites
## Phoenix Web Framework
In order to run this application on your local machine you need to install the `Phoenix` web framework (this implies you also need `Erlang` and `Elixir`).
To install `Phoenix` and the programming languages, check out the installation guide [here](https://hexdocs.pm/phoenix/installation.html).

## Postgresql
The application uses a `Postgresql` database to store users, messages etc. Check out [Postgresql's](https://www.postgresql.org/download/) own guide in order to install it or use a docker image if that is your cup of tea.

# Installation

Clone this repo:
```
git clone https://github.com/Tbobbe/elixir_messenger.git
```

Now, you need to give the application access to the database. In the directory `/config/`, add three files called `dev.secret.exs`, `test.secret.exs` and `prod.secret.exs`. The last two files you can leave eampty. In `dev.secret.exs`, add the following code (but modified with your database credentials):

```elixir
import Config

# Configure your database
config :elixir_messenger, ElixirMessenger.Repo,
  username: "username",
  password: "password",
  hostname: "localhost",
  database: "elixir_messenger_dev",
  stacktrace: true,
  show_sensitive_data_on_connection_error: true,
  pool_size: 10

```

Now you should be ready to start your Phoenix server!

To start your Phoenix server:

  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.setup`
  * Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Now you can create multiple accounts and chat with yourself in real time when you feel lonely!