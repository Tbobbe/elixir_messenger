defmodule ElixirMessenger.Repo.Migrations.CreateFriends do
  use Ecto.Migration

  def change do
    create table(:friends, primary_key: false) do
      add :username1_id, references("users", column: :username, type: :string, on_delete: :delete_all)
      add :username2_id, references("users", column: :username, type: :string, on_delete: :delete_all)
    end

    create index(:friends, [:username1_id])
    create index(:friends, [:username2_id])
    create unique_index(:friends, [:username1_id, :username2_id])
  end
end
