defmodule SFTPClient.InvalidOptionError do
  defexception [:key, :value, :reason]

  def message(error) do
    "Invalid value for option #{error.key}: " <>
      "#{inspect(error.value)} (#{inspect(error.reason)})"
  end
end
