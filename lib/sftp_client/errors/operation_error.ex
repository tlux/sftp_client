defmodule SFTPClient.OperationError do
  defexception [:reason]

  def message(reason) do
    "Operation failed: #{reason}"
  end
end
