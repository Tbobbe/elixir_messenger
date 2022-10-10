defmodule ElixirMessenger.Repo.Migrations.CreateGroupMembers do
  use Ecto.Migration

  def change do
    create table(:group_members, primary_key: false) do
      add :username_id, references("users", column: :username, type: :string, on_delete: :delete_all)
      add :group_id, references("groups", on_delete: :delete_all)
    end

    create index(:group_members, [:username_id])
    create index(:group_members, [:group_id])
    create unique_index(:group_members, [:username_id, :group_id])
  end
end
