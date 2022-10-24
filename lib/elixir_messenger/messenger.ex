defmodule ElixirMessenger.Messenger do
  @moduledoc """
  The Messenger context.
  """

  import Ecto.Query, warn: false
  alias ElixirMessenger.Repo

  alias ElixirMessenger.Messenger.{PersonalMessage, GroupMessage, Group, GroupMember, Friend}

  @doc """
  Returns the list of personal_messages.

  ## Examples

      iex> list_personal_messages()
      [%PersonalMessage{}, ...]

  """
  def list_personal_messages do
    Repo.all(PersonalMessage)
  end

  @doc """
  Gets a single personal_message.

  Raises `Ecto.NoResultsError` if the Personal message does not exist.

  ## Examples

      iex> get_personal_message!(123)
      %PersonalMessage{}

      iex> get_personal_message!(456)
      ** (Ecto.NoResultsError)

  """
  def get_personal_message!(id), do: Repo.get!(PersonalMessage, id)

  @doc """
  Get all personal messages between `username_1` and `username_2`
  """
  def get_chat(username_1, username_2) do
    query = from m in PersonalMessage,
          where: (m.from_id == ^username_1 and m.to_id == ^username_2) or (m.to_id == ^username_1 and m.from_id == ^username_2),
          select: m
    Repo.all(query)
  end

  @doc """
  Creates a personal_message.

  ## Examples

      iex> create_personal_message(%{field: value})
      {:ok, %PersonalMessage{}}

      iex> create_personal_message(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_personal_message(attrs \\ %{}) do
    %PersonalMessage{}
    |> PersonalMessage.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a personal_message.

  ## Examples

      iex> update_personal_message(personal_message, %{field: new_value})
      {:ok, %PersonalMessage{}}

      iex> update_personal_message(personal_message, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_personal_message(%PersonalMessage{} = personal_message, attrs) do
    personal_message
    |> PersonalMessage.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a personal_message.

  ## Examples

      iex> delete_personal_message(personal_message)
      {:ok, %PersonalMessage{}}

      iex> delete_personal_message(personal_message)
      {:error, %Ecto.Changeset{}}

  """
  def delete_personal_message(%PersonalMessage{} = personal_message) do
    Repo.delete(personal_message)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking personal_message changes.

  ## Examples

      iex> change_personal_message(personal_message)
      %Ecto.Changeset{data: %PersonalMessage{}}

  """
  def change_personal_message(%PersonalMessage{} = personal_message, attrs \\ %{}) do
    PersonalMessage.changeset(personal_message, attrs)
  end


  @doc """
  Returns the list of groups.

  ## Examples

      iex> list_groups()
      [%Group{}, ...]

  """
  def list_groups do
    Repo.all(Group)
  end

  @doc """
  Gets a single group.

  Raises `Ecto.NoResultsError` if the Group does not exist.

  ## Examples

      iex> get_group!(123)
      %Group{}

      iex> get_group!(456)
      ** (Ecto.NoResultsError)

  """
  def get_group!(id), do: Repo.get!(Group, id) |> Repo.preload([:messages, :members])

  @doc """
  Creates a group.

  ## Examples

      iex> create_group(%{field: value})
      {:ok, %Group{}}

      iex> create_group(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_group(attrs \\ %{}) do
    %Group{}
    |> Group.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a group.

  ## Examples

      iex> update_group(group, %{field: new_value})
      {:ok, %Group{}}

      iex> update_group(group, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_group(%Group{} = group, attrs) do
    group
    |> Group.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a group.

  ## Examples

      iex> delete_group(group)
      {:ok, %Group{}}

      iex> delete_group(group)
      {:error, %Ecto.Changeset{}}

  """
  def delete_group(%Group{} = group) do
    Repo.delete(group)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking group changes.

  ## Examples

      iex> change_group(group)
      %Ecto.Changeset{data: %Group{}}

  """
  def change_group(%Group{} = group, attrs \\ %{}) do
    Group.changeset(group, attrs)
  end


  @doc """
  Returns the list of group_messages.

  ## Examples

      iex> list_group_messages()
      [%GroupMessage{}, ...]

  """
  def list_group_messages do
    Repo.all(GroupMessage)
  end

  @doc """
  Gets a single group_message.

  Raises `Ecto.NoResultsError` if the Group message does not exist.

  ## Examples

      iex> get_group_message!(123)
      %GroupMessage{}

      iex> get_group_message!(456)
      ** (Ecto.NoResultsError)

  """
  def get_group_message!(id), do: Repo.get!(GroupMessage, id)

  @doc """
  Creates a group_message.

  ## Examples

      iex> create_group_message(%{field: value})
      {:ok, %GroupMessage{}}

      iex> create_group_message(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_group_message(attrs \\ %{}) do
    %GroupMessage{}
    |> GroupMessage.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a group_message.

  ## Examples

      iex> update_group_message(group_message, %{field: new_value})
      {:ok, %GroupMessage{}}

      iex> update_group_message(group_message, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_group_message(%GroupMessage{} = group_message, attrs) do
    group_message
    |> GroupMessage.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a group_message.

  ## Examples

      iex> delete_group_message(group_message)
      {:ok, %GroupMessage{}}

      iex> delete_group_message(group_message)
      {:error, %Ecto.Changeset{}}

  """
  def delete_group_message(%GroupMessage{} = group_message) do
    Repo.delete(group_message)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking group_message changes.

  ## Examples

      iex> change_group_message(group_message)
      %Ecto.Changeset{data: %GroupMessage{}}

  """
  def change_group_message(%GroupMessage{} = group_message, attrs \\ %{}) do
    GroupMessage.changeset(group_message, attrs)
  end


  @doc """
  Creates a group member realationship between a user and a group
  """
  def create_group_member(attrs \\ %{}) do

    %GroupMember{}
    |> GroupMember.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking group_member changes.
  """
  def change_group_member(%GroupMember{} = group_member, attrs \\ %{}) do
    GroupMember.changeset(group_member, attrs)
  end

  @doc """
  Creates a freind relationship between two users
  """
  def create_friend(attrs \\ %{})

  # Obs!, if atoms are used as keys insted of strings, this won't match and only one way relationship will be added
  def create_friend(%{"username1_id" => u1, "username2_id" => u2} = attrs) do

    # Insert two times so that it is a two way relationship
    %Friend{}
    |> Friend.changeset(attrs)
    |> Repo.insert()

    %Friend{}
    |> Friend.changeset(%{"username1_id" => u2, "username2_id" => u1})
    |> Repo.insert()

  end

  # Used for error case
  def create_friend(attrs) do
    %Friend{}
    |> Friend.changeset(attrs)
    |> Repo.insert()
  end

  def change_friend(%Friend{} = friend, attrs \\ %{}) do
    Friend.changeset(friend, attrs)
  end

end
