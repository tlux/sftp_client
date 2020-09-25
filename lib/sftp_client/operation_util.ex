defmodule SFTPClient.OperationUtil do
  @moduledoc false

  alias SFTPClient.ConnError
  alias SFTPClient.InvalidOptionError
  alias SFTPClient.OperationError

  @spec sftp_adapter() :: module
  def sftp_adapter do
    Application.get_env(:sftp_client, :sftp_adapter, :ssh_sftp)
  end

  @spec ssh_adapter() :: module
  def ssh_adapter do
    Application.get_env(:sftp_client, :ssh_adapter, :ssh)
  end

  @spec may_bang!(:ok | {:ok | :error, any}) :: any | no_return
  def may_bang!(result)

  def may_bang!(:ok), do: :ok

  def may_bang!({:ok, result}), do: result

  def may_bang!({:error, %{__exception__: _} = error}), do: raise(error)

  def may_bang!({:error, error}) do
    raise("Unexpected error: #{inspect(error)}")
  end

  @spec handle_error(any) ::
          ConnError.t() | InvalidOptionError.t() | OperationError.t()
  def handle_error(error)

  def handle_error({:eoptions, {{key, value}, reason}}) do
    %InvalidOptionError{key: key, value: load_opt_value(value), reason: reason}
  end

  def handle_error(reason) when is_atom(reason) do
    %OperationError{reason: reason}
  end

  def handle_error(message) do
    %ConnError{message: to_string(message)}
  end

  defp load_opt_value(value) when is_list(value), do: to_string(value)
  defp load_opt_value(value), do: value
end
