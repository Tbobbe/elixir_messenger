defmodule ElixirMessenger.Messenger.Friend do
  use Ecto.Schema
  import Ecto.Changeset
  alias ElixirMessenger.Accounts.User

  @primary_key false
  schema "friends" do
    belongs_to :username1, User, references: :username, type: :string
    belongs_to :username2, User, references: :username, type: :string
  end

  @doc false
  def changeset(friend, attrs) do
    friend
    |> cast(attrs, [:username1_id, :username2_id])
    |> validate_required([:username1_id, :username2_id])
    |> foreign_key_constraint(:username1_id)
    |> foreign_key_constraint(:username2_id)
    |> check_constraint(:username1_id, name: :can_not_be_friend_with_thyself, message: "can not befriend yourself")
    |> unique_constraint([:username1_id, :username2_id])
    |> unique_constraint([:username2_id, :username1_id])
    ## TODO: fix the unique constraint
    # |> unique_constraint(:username1_id, name: :friends_username1_id_username2_id_index)
    # |> unique_constraint(:username2_id, name: :friends_username1_id_username2_id_index)
  end

end
