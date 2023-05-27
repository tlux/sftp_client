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
        decode_private_key(
          path,
          provider_opts[:private_key_pass_phrase],
          algorithm
        )
    end
  end

  defp decode_private_key(path, pass_phrase, algorithm) do
    full_path = Path.expand(path)

    case File.read(full_path) do
      {:ok, key_contents} ->
        case decode_private_key_contents(key_contents, pass_phrase, algorithm) do
          {:error, 'Unable to decode key'} = error ->
            Logger.error("Unable to decode key: #{path}")
            error

          {:error, 'Passphrase required'} = error ->
            Logger.error("Passphrase required for key: #{path}")
            error

          result ->
            result
        end

      _ ->
        Logger.error("Specified key not found: #{full_path}")
        {:error, 'Key not found'}
    end
  end

  defp decode_private_key_contents(key_contents, pass_phrase, algorithm) do
    key_contents
    |> :public_key.pem_decode()
    |> List.first()
    |> case do
      nil ->
        {:error, 'Unable to decode key'}

      {{_, :new_openssh}, _key, _} ->
        decode_new_openssh_private_key_contents(
          key_contents,
          pass_phrase,
          algorithm
        )

      {_type, _key, :not_encrypted} = entry ->
        {:ok, :public_key.pem_entry_decode(entry)}

      _entry when is_nil(pass_phrase) ->
        {:error, 'Passphrase required'}

      entry ->
        pass_phrase = String.to_charlist(pass_phrase)
        {:ok, :public_key.pem_entry_decode(entry, pass_phrase)}
    end
  end

  defp decode_new_openssh_private_key_contents(
         key_contents,
         pass_phrase,
         algorithm
       ) do
    with {:ok, decoded_keys} <-
           :ssh_file.decode_ssh_file(
             :private,
             algorithm,
             key_contents,
             pass_phrase
           ),
         {decoded_key, _} <- List.first(decoded_keys) do
      {:ok, decoded_key}
    else
      _result -> {:error, 'Unable to decode key'}
    end
  end
end
