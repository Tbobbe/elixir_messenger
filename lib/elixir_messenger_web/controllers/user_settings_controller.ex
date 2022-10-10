defmodule ElixirMessengerWeb.UserSettingsController do
  use ElixirMessengerWeb, :controller

  alias ElixirMessenger.Accounts
  alias ElixirMessengerWeb.UserAuth

  plug :assign_password_and_username_changesets

  def edit(conn, _params) do
    render(conn, "edit.html")
  end

  def update(conn, %{"action" => "update_password"} = params) do
    %{"current_password" => password, "user" => user_params} = params
    user = conn.assigns.current_user

    case Accounts.update_user_password(user, password, user_params) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "Password updated successfully.")
        |> put_session(:user_return_to, Routes.user_settings_path(conn, :edit))
        |> UserAuth.log_in_user(user)

      {:error, changeset} ->
        render(conn, "edit.html", password_changeset: changeset)
    end
  end

  def update(conn, %{"action" => "update_username"} = params) do
    %{"user" => user_params} = params                             # Get params provided by the form
    user = conn.assigns.current_user                              # Get current user

    case Accounts.update_user_username(user, user_params) do      # Update user data
      {:ok, user} -> # (OBS, new user)
        conn
        |> put_flash(:info, "Username updated successfully.")
        |> put_session(:user_return_to, Routes.user_settings_path(conn, :edit)) # Put this in so that the login function can return us to the edit page
        |> UserAuth.log_in_user(user)                                           # Login the (updated) user (changes to the user deletes all associated tokens)

        {:error, changeset} ->
        render(conn, "edit.html", username_changeset: changeset)  # Display error data provided by the changeset
    end
  end

  defp assign_password_and_username_changesets(conn, _opts) do
    user = conn.assigns.current_user

    conn
    |> assign(:username_changeset, Accounts.change_user_username(user))
    |> assign(:password_changeset, Accounts.change_user_password(user))
  end
end
