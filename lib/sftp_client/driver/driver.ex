defmodule SFTPClient.Driver do
  @callback run(module, fun :: atom, args :: [any]) :: any

  @doc """
  Gets the configured driver.
  """
  @spec driver() :: module
  def driver do
    Application.get_env(:sftp_client, :driver, SFTPClient.Driver.Common)
  end

  @doc """
  Runs the operation defined by module, function and args with the configured
  driver.
  """
  @spec run(module, fun :: atom, args :: [any]) :: any
  def run(module, fun, args) do
    driver().run(module, fun, args)
  end
end
