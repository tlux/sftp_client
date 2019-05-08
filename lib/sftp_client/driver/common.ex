defmodule SFTPClient.Driver.Common do
  @moduledoc """
  A module implementing the `SFTPClient.Driver` behavior by simply delegating
  to `Kernel.apply/3`.
  """

  @behaviour SFTPClient.Driver

  @impl true
  def run(module, fun, args) do
    apply(module, fun, args)
  end
end
