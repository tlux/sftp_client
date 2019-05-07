defmodule SFTPClient.Operation do
  alias SFTPClient.ConnError
  alias SFTPClient.InvalidOptionError
  alias SFTPClient.OperationError

  defmacro __using__(_) do
    quote do
      import SFTPClient, only: [sftp_adapter: 0, ssh_adapter: 0]
      import unquote(__MODULE__)

      alias SFTPClient.Conn
    end
  end

  @doc """
  Converts the result of a non-bang function so that the result is returned or
  an exception is raised on error.
  """
  @spec may_bang!(:ok | {:ok | :error, any}) :: any | no_return
  def may_bang!(result)
  def may_bang!(:ok), do: :ok
  def may_bang!({:ok, result}), do: result
  def may_bang!({:error, error}), do: raise(error)

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
