defmodule SFTPClient.KeyProvider do
  @moduledoc """
  A provider that loads keys for authentication from the given location.
  Implements the `:ssh_client_key_api` behavior.
  """

  @behaviour :ssh_client_key_api

  @impl true
  defdelegate add_host_key(host, public_key, opts), to: :ssh_file

  @impl true
  defdelegate is_host_key(key, host, algorithm, opts), to: :ssh_file

  @impl true
  def user_key(algorithm, opts) do
    provider_opts = opts[:key_cb_private]

    case provider_opts[:private_key_path] do
      nil ->
        :ssh_file.user_key(algorithm, opts)

      path ->
        decode_private_key(path, provider_opts[:private_key_passphrase])
    end
  end

  defp decode_private_key(path, passphrase) do
    path
    |> Path.expand()
    |> File.read!()
    |> :public_key.pem_decode()
    |> List.first()
    |> case do
      nil ->
        {:error, 'Undecodable key'}

      {_type, _key, :not_encrypted} = entry ->
        {:ok, :public_key.pem_entry_decode(entry)}

      _entry when is_nil(passphrase) ->
        {:error, 'Passphrase required'}

      entry ->
        passphrase = String.to_charlist(passphrase)
        {:ok, :public_key.pem_entry_decode(entry, passphrase)}
    end
  end
end
