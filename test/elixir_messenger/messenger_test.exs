defmodule ElixirMessenger.MessengerTest do
  use ElixirMessenger.DataCase

  alias ElixirMessenger.Messenger

  describe "personal_messages" do
    alias ElixirMessenger.Messenger.PersonalMessage

    import ElixirMessenger.MessengerFixtures

    @invalid_attrs %{from: nil, message: nil, to: nil}

    test "list_personal_messages/0 returns all personal_messages" do
      personal_message = personal_message_fixture()
      assert Messenger.list_personal_messages() == [personal_message]
    end

    test "get_personal_message!/1 returns the personal_message with given id" do
      personal_message = personal_message_fixture()
      assert Messenger.get_personal_message!(personal_message.id) == personal_message
    end

    test "create_personal_message/1 with valid data creates a personal_message" do
      valid_attrs = %{from: "some from", message: "some message", to: "some to"}

      assert {:ok, %PersonalMessage{} = personal_message} = Messenger.create_personal_message(valid_attrs)
      assert personal_message.from == "some from"
      assert personal_message.message == "some message"
      assert personal_message.to == "some to"
    end

    test "create_personal_message/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Messenger.create_personal_message(@invalid_attrs)
    end

    test "update_personal_message/2 with valid data updates the personal_message" do
      personal_message = personal_message_fixture()
      update_attrs = %{from: "some updated from", message: "some updated message", to: "some updated to"}

      assert {:ok, %PersonalMessage{} = personal_message} = Messenger.update_personal_message(personal_message, update_attrs)
      assert personal_message.from == "some updated from"
      assert personal_message.message == "some updated message"
      assert personal_message.to == "some updated to"
    end

    test "update_personal_message/2 with invalid data returns error changeset" do
      personal_message = personal_message_fixture()
      assert {:error, %Ecto.Changeset{}} = Messenger.update_personal_message(personal_message, @invalid_attrs)
      assert personal_message == Messenger.get_personal_message!(personal_message.id)
    end

    test "delete_personal_message/1 deletes the personal_message" do
      personal_message = personal_message_fixture()
      assert {:ok, %PersonalMessage{}} = Messenger.delete_personal_message(personal_message)
      assert_raise Ecto.NoResultsError, fn -> Messenger.get_personal_message!(personal_message.id) end
    end

    test "change_personal_message/1 returns a personal_message changeset" do
      personal_message = personal_message_fixture()
      assert %Ecto.Changeset{} = Messenger.change_personal_message(personal_message)
    end
  end

  describe "groups" do
    alias ElixirMessenger.Messenger.Group

    import ElixirMessenger.MessengerFixtures

    @invalid_attrs %{groupname: nil}

    test "list_groups/0 returns all groups" do
      group = group_fixture()
      assert Messenger.list_groups() == [group]
    end

    test "get_group!/1 returns the group with given id" do
      group = group_fixture()
      assert Messenger.get_group!(group.id) == group
    end

    test "create_group/1 with valid data creates a group" do
      valid_attrs = %{groupname: "some groupname"}

      assert {:ok, %Group{} = group} = Messenger.create_group(valid_attrs)
      assert group.groupname == "some groupname"
    end

    test "create_group/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Messenger.create_group(@invalid_attrs)
    end

    test "update_group/2 with valid data updates the group" do
      group = group_fixture()
      update_attrs = %{groupname: "some updated groupname"}

      assert {:ok, %Group{} = group} = Messenger.update_group(group, update_attrs)
      assert group.groupname == "some updated groupname"
    end

    test "update_group/2 with invalid data returns error changeset" do
      group = group_fixture()
      assert {:error, %Ecto.Changeset{}} = Messenger.update_group(group, @invalid_attrs)
      assert group == Messenger.get_group!(group.id)
    end

    test "delete_group/1 deletes the group" do
      group = group_fixture()
      assert {:ok, %Group{}} = Messenger.delete_group(group)
      assert_raise Ecto.NoResultsError, fn -> Messenger.get_group!(group.id) end
    end

    test "change_group/1 returns a group changeset" do
      group = group_fixture()
      assert %Ecto.Changeset{} = Messenger.change_group(group)
    end
  end

  describe "group_messages" do
    alias ElixirMessenger.Messenger.GroupMessage

    import ElixirMessenger.MessengerFixtures

    @invalid_attrs %{from_id: nil, message: nil, to_id: nil}

    test "list_group_messages/0 returns all group_messages" do
      group_message = group_message_fixture()
      assert Messenger.list_group_messages() == [group_message]
    end

    test "get_group_message!/1 returns the group_message with given id" do
      group_message = group_message_fixture()
      assert Messenger.get_group_message!(group_message.id) == group_message
    end

    test "create_group_message/1 with valid data creates a group_message" do
      valid_attrs = %{from_id: "some from_id", message: "some message", to_id: "some to_id"}

      assert {:ok, %GroupMessage{} = group_message} = Messenger.create_group_message(valid_attrs)
      assert group_message.from_id == "some from_id"
      assert group_message.message == "some message"
      assert group_message.to_id == "some to_id"
    end

    test "create_group_message/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Messenger.create_group_message(@invalid_attrs)
    end

    test "update_group_message/2 with valid data updates the group_message" do
      group_message = group_message_fixture()
      update_attrs = %{from_id: "some updated from_id", message: "some updated message", to_id: "some updated to_id"}

      assert {:ok, %GroupMessage{} = group_message} = Messenger.update_group_message(group_message, update_attrs)
      assert group_message.from_id == "some updated from_id"
      assert group_message.message == "some updated message"
      assert group_message.to_id == "some updated to_id"
    end

    test "update_group_message/2 with invalid data returns error changeset" do
      group_message = group_message_fixture()
      assert {:error, %Ecto.Changeset{}} = Messenger.update_group_message(group_message, @invalid_attrs)
      assert group_message == Messenger.get_group_message!(group_message.id)
    end

    test "delete_group_message/1 deletes the group_message" do
      group_message = group_message_fixture()
      assert {:ok, %GroupMessage{}} = Messenger.delete_group_message(group_message)
      assert_raise Ecto.NoResultsError, fn -> Messenger.get_group_message!(group_message.id) end
    end

    test "change_group_message/1 returns a group_message changeset" do
      group_message = group_message_fixture()
      assert %Ecto.Changeset{} = Messenger.change_group_message(group_message)
    end
  end
end
