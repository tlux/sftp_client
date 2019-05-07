defmodule SFTPClient.Operations.MakeSymlink do
  use SFTPClient.Operation

  @doc """
  Creates a symbolic link pointing to `target_path` with the name
  `symlink_path`.
  """
  @spec make_symlink(Conn.t(), String.t(), String.t()) :: :ok | {:error, any}
  def make_symlink(%Conn{} = conn, symlink_path, target_path) do
    conn.channel_pid
    |> sftp_adapter().make_symlink(
      String.to_charlist(symlink_path),
      String.to_charlist(target_path)
    )
    |> case do
      :ok -> :ok
      {:error, error} -> {:error, handle_error(error)}
    end
  end

  @doc """
  Creates a symbolic link pointing to `target_path` with the name
  `symlink_path`. Raises when the operation fails.
  """
  @spec make_symlink!(Conn.t(), String.t(), String.t()) :: :ok | no_return
  def make_symlink!(%Conn{} = conn, symlink_path, target_path) do
    conn |> make_symlink(symlink_path, target_path) |> may_bang!()
  end
end
