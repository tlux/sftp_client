defmodule SFTPClient.KeyProvider do
  @moduledoc """
  A provider that loads keys for authentication from the given location.
  Implements the `:ssh_client_key_api` behavior.
  """

  @behaviour :ssh_client_key_api

  require Logger

  if String.to_integer(System.otp_release()) >= 23 do
    @impl true
    defdelegate add_host_key(host, port, public_key, opts), to: :ssh_file

    @impl true
    defdelegate is_host_key(key, host, port, algorithm, opts), to: :ssh_file
  else
    @impl true
    defdelegate add_host_key(host, public_key, opts), to: :ssh_file

    @impl true
    defdelegate is_host_key(key, host, algorithm, opts), to: :ssh_file
  end

  @impl true
  def user_key(algorithm, opts) do
    provider_opts = opts[:key_cb_private]

    case provider_opts[:private_key_path] do
      nil ->
        :ssh_file.user_key(algorithm, opts)

      path ->
        decode_private_key(path, provider_opts[:private_key_pass_phrase])
    end
  end

  defp decode_private_key(path, pass_phrase) do
    full_path = Path.expand(path)

    case File.read(full_path) do
      {:ok, key_contents} ->
        key_contents
        |> :public_key.pem_decode()
        |> List.first()
        |> case do
          nil ->
            Logger.error("Unable to decode key: #{path}")
            {:error, 'Unable to decode key'}

          {_type, _key, :not_encrypted} = entry ->
            {:ok, :public_key.pem_entry_decode(entry)}

          _entry when is_nil(pass_phrase) ->
            Logger.error("Passphrase required for key: #{path}")
            {:error, 'Passphrase required'}

          entry ->
            pass_phrase = String.to_charlist(pass_phrase)
            {:ok, :public_key.pem_entry_decode(entry, pass_phrase)}
        end

      _ ->
        Logger.error("Specified key not found: #{full_path}")
        {:error, 'Key not found'}
    end
  end
end
