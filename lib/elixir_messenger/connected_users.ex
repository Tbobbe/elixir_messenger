defmodule ElixirMessenger.ConnectedUsers do
  use Agent

  alias ElixirMessenger.Messenger
  alias ElixirMessenger.Accounts

  @moduledoc """
  Mudule using an agent to store connected users and groups
  """

  @doc """
  Initializes the Agent as an empty map
  """
  def start_link(_opts) do
    Agent.start_link(fn -> %{users: %{}, groups: %{}} end, name: __MODULE__)
  end

  @doc """
  Adds a user entry to the state where the `username` is the key and the `pid` is the value
  """
  def put_user(username, pid) do
    Agent.update(__MODULE__, fn state -> %{state | users: Map.put(state.users, username, pid)} end)
  end

  @doc """
  Clear the whole state
  """
  def clear_map do
    Agent.update(__MODULE__, fn _ -> %{users: %{}, groups: %{}} end)
  end

  @doc """
  Remove a single user from the state
  """
  def remove_user(username) do
    Agent.update(__MODULE__, fn state -> %{state | users: Map.delete(state.users, username)} end)
  end

  @doc """
  Send a personal `message` to `username` if `username` is connected
  """
  def user_got_message(username, message) do
    possible_pid = Agent.get(__MODULE__, &Map.get(&1.users, username))
    if possible_pid do
      Process.send(possible_pid, {:got_personal_message, message}, [])
    end
  end

  @doc """
  Add a group to the state where the key is `group_id` and the value a list of usernames
  """
  def put_group(group_id) do
    if(group_id not in Agent.get(__MODULE__, &Map.keys(&1.groups))) do
      group = Messenger.get_group!(group_id)
      group_members = group.members |> Enum.map(&(&1.username))
      Agent.update(__MODULE__, fn state -> %{state | groups: Map.put(state.groups, group_id, group_members)} end)
    end
  end

  @doc """
  Sends `message` to every connected user that is part of `group_id`
  """
  def group_got_message(group_id, message) do
    group_members = Agent.get(__MODULE__, &Map.get(&1.groups, group_id))
    Enum.map(group_members,
      fn member ->
        if member in Agent.get(__MODULE__, &Map.keys(&1.users)) do
          Agent.get(__MODULE__, &Map.get(&1.users, member)) |> Process.send({:got_group_message, message}, [])
        end
      end
    )
  end

  @doc """
  Send a send the other user to concerned parties when a friendship is formed
  """
  def friend_added(friend) do
    possible_pid = Agent.get(__MODULE__, &Map.get(&1.users, friend.username2_id))
    if possible_pid do
      user = Accounts.get_user_by_username_no_preload(friend.username1_id)
      Process.send(possible_pid, {:got_new_friend, user}, [])
    end

    # Also send friend update to sender pid so that sender does not have to reload the user profile
    sender_pid = Agent.get(__MODULE__, &Map.get(&1.users, friend.username1_id))
    user = Accounts.get_user_by_username_no_preload(friend.username2_id)
    Process.send(sender_pid, {:got_new_friend, user}, [])
  end

  @doc """
  Notifies a user that it has been added to a group by sending the group details
  """
  def group_member_added(group_member) do
    possible_pid = Agent.get(__MODULE__, &Map.get(&1.users, group_member.username_id))
    if possible_pid do
      group = Messenger.get_group!(group_member.group_id)
      Process.send(possible_pid, {:got_new_group_membership, group}, [])
    end
  end

end
