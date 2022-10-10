defmodule ElixirMessenger.Messenger.Group do
  use Ecto.Schema
  import Ecto.Changeset

  alias ElixirMessenger.Accounts.User
  alias ElixirMessenger.Messenger.{GroupMessage}

  schema "groups" do
    field :groupname, :string

    timestamps()

    has_many :messages, GroupMessage, foreign_key: :to_id

    many_to_many :members,  User, join_through: "group_members", join_keys: [group_id: :id, username_id: :username] # groupname is not id nor unique so use the gernereted id

  end

  @doc false
  def changeset(group, attrs) do
    group
    |> cast(attrs, [:groupname])
    |> validate_required([:groupname])
  end
end
