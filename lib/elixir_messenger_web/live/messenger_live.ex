defmodule ElixirMessengerWeb.MessengerLive do
  use ElixirMessengerWeb, :live_view
  on_mount  ElixirMessengerWeb.UserLiveAuth # Authenticate and put current user into socket

  alias ElixirMessenger.Messenger
  #alias ElixirMessenger.Accounts
  alias ElixirMessenger.Messenger.{PersonalMessage, Group, GroupMember, GroupMessage, Friend}
  alias ElixirMessenger.ConnectedUsers

  def mount(_params, _session, socket) do
    ConnectedUsers.put_user(socket.assigns.current_user.username, self())
    socket.assigns.current_user.groups |> Enum.map(&ConnectedUsers.put_group(&1.id))
    {:ok, give_assigns(socket)}
  end

  def handle_event("get_user_chat", %{"uname" => uname}, socket) do # Could memoize this perhaps but would add complexity when fetching chats with new messages
    new_chat = Messenger.get_chat(socket.assigns.current_user.username, uname)
    updated_socket = socket
      |> assign(:selected_friend, uname)
      |> assign(:chat_content, new_chat)
      |> assign(:group_active?, false)
      |> assign(:unread_messages, List.delete(socket.assigns.unread_messages, uname))
    {:noreply, updated_socket}
  end

  def handle_event("get_group_chat", %{"group_id" => group_id}, socket) do # same comment as above
    group = Messenger.get_group!(group_id)
    updated_socket = socket
      |> assign(:selected_group, group)
      |> assign(:chat_content, group.messages)
      |> assign(:group_active?, true)
      |> assign(:unread_messages, List.delete(socket.assigns.unread_messages, String.to_integer(group_id)))
    {:noreply, updated_socket}
  end

  def handle_event("send_personal_message", %{"personal_message" => user_params}, socket) do
    user_params = user_params
      |> Map.put("from_id", socket.assigns.current_user.username)
      |> Map.put("to_id", socket.assigns.selected_friend)

    case Messenger.create_personal_message(user_params) do
      {:ok, message} ->
        ConnectedUsers.user_got_message(message.to_id, message)
        {:noreply, assign(socket, :chat_content, socket.assigns.chat_content ++ [message])} # Bad performance but need messsage last so is ok ;)
      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :message, changeset)}
    end
  end

  def handle_event("send_group_message", %{"group_message" => user_params}, socket) do
    user_params = user_params
      |> Map.put("from_id", socket.assigns.current_user.username)
      |> Map.put("to_id", socket.assigns.selected_group.id)

      case Messenger.create_group_message(user_params) do
        {:ok, message} ->
          ConnectedUsers.group_got_message(socket.assigns.selected_group.id, message)
          {:noreply, socket}
        {:error, %Ecto.Changeset{} = changeset} ->
          {:noreply, assign(socket, :group_message, changeset)}
      end
  end

  def handle_event("add_friend", %{"friend" => user_params}, socket) do
    user_params = Map.put(user_params, "username2_id", socket.assigns.current_user.username)

    case Messenger.create_friend(user_params) do
      {:ok, friend} ->
        ConnectedUsers.friend_added(friend)
        socket = socket |> put_flash(:info, "Friend added!")
        {:noreply, socket}
      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :friend, changeset)}
    end
  end

  def handle_event("create_group", %{"group" => user_params}, socket) do
    with(
      {:ok, group} <- Messenger.create_group(user_params),
      {:ok, group_member} <- Messenger.create_group_member(%{username_id: socket.assigns.current_user.username, group_id: group.id})
    ) do
      ConnectedUsers.group_member_added(group_member)
      {:noreply, socket |> put_flash(:info, "Group created!")}
    else
      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :group, changeset)}
      {:error, _changeset} ->
         {:noreply, put_flash(socket, :error, "Group was created but could not add you to it")}
    end
  end

  def handle_event("add_group_member", %{"group_member" => user_params}, socket) do
    user_params = Map.put(user_params, "group_id", socket.assigns.selected_group.id)
    case Messenger.create_group_member(user_params) do
      {:ok, group_member} ->
        ConnectedUsers.group_member_added(group_member)
        updated_group = Messenger.get_group!(socket.assigns.selected_group.id) # Not sure how to fix so this won't have to be called atm
        socket = socket |> assign(:selected_group, updated_group) |> put_flash(:info, "User added to group!")
        {:noreply, socket}
      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :group_member_changeset, changeset)}
    end
  end

  def handle_info({:got_personal_message, message}, socket) do
    if message.from_id === socket.assigns.selected_friend and not socket.assigns.group_active? do
      {:noreply, assign(socket, :chat_content, socket.assigns.chat_content ++ [message])}
    else
      {:noreply, assign(socket, :unread_messages, [message.from_id | socket.assigns.unread_messages])}
    end
  end

  def handle_info({:got_group_message, message}, socket) do
    if socket.assigns.group_active? and socket.assigns.selected_group.id === message.to_id do
      {:noreply, assign(socket, :chat_content, socket.assigns.chat_content ++ [message])}
    else
      {:noreply, assign(socket, :unread_messages, [message.to_id | socket.assigns.unread_messages])}
    end
  end

  def handle_info({:got_new_friend, user}, socket) do
    updated_user = %{socket.assigns.current_user | friends: [user | socket.assigns.current_user.friends]}
    {:noreply, assign(socket, :current_user, updated_user)}
  end

  def handle_info({:got_new_group_membership, group}, socket) do
    updated_user = %{socket.assigns.current_user | groups: [group | socket.assigns.current_user.groups]}
    {:noreply, assign(socket, :current_user, updated_user)}
  end

  defp give_assigns(socket) do
    socket
    |> assign(:selected_friend, "")
    |> assign(:selected_group, "")
    |> assign(:group_active?, false)
    |> assign(:chat_content, [])
    |> assign(:unread_messages, [])
    |> assign(:message, Messenger.change_personal_message(%PersonalMessage{}))
    |> assign(:group_message, Messenger.change_group_message(%GroupMessage{}))
    |> assign(:friend, Messenger.change_friend(%Friend{}))
    |> assign(:group, Messenger.change_group(%Group{}))
    |> assign(:group_member_changeset, Messenger.change_group_member(%GroupMember{}))
  end
end
