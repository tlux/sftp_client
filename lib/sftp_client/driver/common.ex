defmodule SFTPClient.Driver.Common do
  @behaviour SFTPClient.Driver

  @impl true
  def run(module, fun, args) do
    apply(module, fun, args)
  end
end
