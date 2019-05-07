defmodule SFTPClient.Operations.ListDir do
  use SFTPClient.Operation

  @spec list_dir(Conn.t(), String.t()) :: {:ok, [String.t()]} | {:error, any}
  def list_dir(%Conn{} = conn, path) do
    conn.channel_pid
    |> sftp_adapter().list_dir(String.to_charlist(path))
    |> case do
      {:ok, entries} ->
        {:ok,
         entries
         |> Enum.map(&to_string/1)
         |> Enum.reject(&(&1 in [".", ".."]))
         |> Enum.sort()}

      {:error, error} ->
        {:error, handle_error(error)}
    end
  end

  @spec list_dir!(Conn.t(), String.t()) :: [String.t()] | no_return
  def list_dir!(%Conn{} = conn, path) do
    conn |> list_dir(path) |> bangify!()
  end
end
