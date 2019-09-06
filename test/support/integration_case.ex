defmodule SFTPClient.IntegrationCase do
  use ExUnit.CaseTemplate

  using do
    quote do
      @moduletag :integration
    end
  end

  setup do
    prev_sftp_adapter = Application.get_env(:sftp_client, :sftp_adapter)
    prev_ssh_adapter = Application.get_env(:sftp_client, :ssh_adapter)

    Application.delete_env(:sftp_client, :sftp_adapter)
    Application.delete_env(:sftp_client, :ssh_adapter)

    on_exit(fn ->
      Application.put_env(:sftp_client, :sftp_adapter, prev_sftp_adapter)
      Application.put_env(:sftp_client, :ssh_adapter, prev_ssh_adapter)
    end)

    :ok
  end
end
