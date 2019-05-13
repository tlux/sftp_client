defmodule SFTPClient.InvalidOptionError do
  @moduledoc """
  An error that is raised when the configuration contains invalid options.
  """

  defexception [:key, :value, :reason]

  @type t :: %__MODULE__{key: atom, value: any, reason: term}

  def message(error) do
    "Invalid value for option #{error.key}: " <>
      "#{inspect(error.value)} (#{inspect(error.reason)})"
  end
end
