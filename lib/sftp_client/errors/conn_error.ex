defmodule SFTPClient.ConnError do
  @moduledoc """
  An error that is raised when connection to the SFTP server failed.
  """

  defexception [:message]
end
