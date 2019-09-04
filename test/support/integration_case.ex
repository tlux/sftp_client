defmodule SFTPClient.IntegrationCase do
  use ExUnit.CaseTemplate

  using do
    quote do
      @moduletag :integration
    end
  end

  setup do
    prev_config = Application.get_all_env(:sftp_client)

    Application.delete_env(:sftp_client, :sftp_adapter)
    Application.delete_env(:sftp_client, :ssh_adapter)

    on_exit(fn ->
      Application.put_all_env(sftp_client: prev_config)
    end)

    :ok
  end
end
