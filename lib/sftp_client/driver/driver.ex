defmodule SFTPClient.Driver do
  @moduledoc """
  A behavior that can be implemented by your own modules to mock or stub SFTP
  operations. You can set a custom driver by specifying it in your config:

      config :sftp_client, :driver, MySFTPMock

  The default driver is `SFTPClient.Driver.Common`.
  """

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
