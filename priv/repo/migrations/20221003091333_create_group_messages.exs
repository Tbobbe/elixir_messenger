defmodule ElixirMessenger.Repo.Migrations.CreateGroupMessages do
  use Ecto.Migration

  def change do
    create table(:group_messages) do
      add :message, :text, null: false
      add :from_id, references("users", column: :username, type: :string, on_delete: :delete_all)
      add :to_id, references("groups", on_delete: :delete_all)

      timestamps()
    end

    create index(:group_messages, [:to_id]) # We probably always get all group messages to a specific group in a query, so we create an index

  end
end
