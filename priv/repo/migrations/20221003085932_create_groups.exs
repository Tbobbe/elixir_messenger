defmodule ElixirMessenger.Repo.Migrations.CreateGroups do
  use Ecto.Migration

  def change do
    create table(:groups) do
      add :groupname, :string, null: false

      timestamps()
    end
  end
end
