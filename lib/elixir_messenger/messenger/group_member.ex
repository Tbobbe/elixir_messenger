defmodule ElixirMessenger.Messenger.GroupMember do
  use Ecto.Schema
  import Ecto.Changeset
  alias ElixirMessenger.Accounts.User
  alias ElixirMessenger.Messenger.Group

  @primary_key false
  schema "group_members" do
    belongs_to :username, User, references: :username, type: :string # Assumes reference table column name of "from_id"
    belongs_to :group, Group
  end

  @doc false
  def changeset(group_member, attrs) do
    group_member
    |> cast(attrs, [:username_id, :group_id])
    |> validate_required([:username_id, :group_id])
    |> foreign_key_constraint(:username_id)
    |> foreign_key_constraint(:group_id)
    |> unique_constraint([:username_id, :group_id])
  end

end
