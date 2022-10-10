defmodule ElixirMessenger.MessengerFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `ElixirMessenger.Messenger` context.
  """

  @doc """
  Generate a personal_message.
  """
  def personal_message_fixture(attrs \\ %{}) do
    {:ok, personal_message} =
      attrs
      |> Enum.into(%{
        from: "some from",
        message: "some message",
        to: "some to"
      })
      |> ElixirMessenger.Messenger.create_personal_message()

    personal_message
  end

  @doc """
  Generate a group.
  """
  def group_fixture(attrs \\ %{}) do
    {:ok, group} =
      attrs
      |> Enum.into(%{
        groupname: "some groupname"
      })
      |> ElixirMessenger.Messenger.create_group()

    group
  end

  @doc """
  Generate a group_message.
  """
  def group_message_fixture(attrs \\ %{}) do
    {:ok, group_message} =
      attrs
      |> Enum.into(%{
        from_id: "some from_id",
        message: "some message",
        to_id: "some to_id"
      })
      |> ElixirMessenger.Messenger.create_group_message()

    group_message
  end
end
