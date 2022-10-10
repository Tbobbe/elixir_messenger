defmodule ElixirMessenger.Messenger.GroupMessage do
  use Ecto.Schema
  import Ecto.Changeset

  alias ElixirMessenger.Accounts.User
  alias ElixirMessenger.Messenger.{Group}

  schema "group_messages" do
    field :message, :string
    belongs_to :from, User, references: :username, type: :string
    belongs_to :to, Group

    timestamps()
  end

  @doc false
  def changeset(group_message, attrs) do
    group_message
    |> cast(attrs, [:message, :from_id, :to_id])
    |> validate_required([:message, :from_id, :to_id])
    |> foreign_key_constraint(:from_id)
    |> foreign_key_constraint(:to_id)
  end
end
