defmodule ElixirMessenger.Repo.Migrations.AddFriendConstraint do
  use Ecto.Migration

  def change do
    create constraint("friends", :can_not_be_friend_with_thyself, check: "username1_id != username2_id")
  end
end
