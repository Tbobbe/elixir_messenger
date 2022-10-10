defmodule ElixirMessenger.Repo.Migrations.CreatePersonalMessages do
  use Ecto.Migration

  def change do
    create table(:personal_messages) do
      add :message, :text, null: false
      add :from_id, references("users", column: :username, type: :string, on_delete: :delete_all)
      add :to_id, references("users", column: :username, type: :string, on_delete: :delete_all)

      timestamps()
    end
  end
end
