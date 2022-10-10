defmodule ElixirMessenger.Messenger.PersonalMessage do
  use Ecto.Schema
  import Ecto.Changeset
  alias ElixirMessenger.Accounts.User

  schema "personal_messages" do
    field :message, :string
    belongs_to :from, User, references: :username, type: :string # Assumes reference table column name of "from_id"
    belongs_to :to, User, references: :username, type: :string

    timestamps()
  end

  @doc false
  def changeset(personal_message, attrs) do
    personal_message
    |> cast(attrs, [:message, :from_id, :to_id])
    |> validate_required([:message, :from_id, :to_id])
    |> foreign_key_constraint(:from_id)
    |> foreign_key_constraint(:to_id)
  end
end
