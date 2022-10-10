defmodule ElixirMessengerWeb.UserLiveAuth do
  import Phoenix.LiveView

  def on_mount(:default, _params, session, socket) do
    case session do
      %{"user_token" => user_token} ->
        socket = assign_new(socket, :current_user, fn ->
          ElixirMessenger.Accounts.get_user_by_session_token(user_token)
        end)
        {:cont, socket}
      %{} ->
        {:halt,
          socket
          |> put_flash(:error, "You have to Sign in to continue")
          |> redirect(to: "/users/log_in")}
    end
  end
end
