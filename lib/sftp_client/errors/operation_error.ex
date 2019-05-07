defmodule SFTPClient.OperationError do
  defexception [:reason]

  def message(error) do
    "Operation failed: #{error.reason}"
  end
end
