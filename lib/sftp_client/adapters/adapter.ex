defmodule SFTPClient.Adapter do
  alias SFTPClient.Config
  alias SFTPClient.Session

  @callback connect(Config.t()) :: {:ok, Session.t()} | {:error, term}

  @callback disconnect(Session.t()) :: :ok

  @callback list_dir(Session.t(), path :: String.t()) ::
              {:ok, [String.t()]} | {:error, term}

  @callback read_file(Session.t(), path :: String.t()) ::
              {:ok, String.t()} | {:error, term}

  @callback file_info(Session.t(), path :: String.t()) ::
              {:ok, File.Stat.t()} | {:error, term}

  @callback download_file(
              Session.t(),
              remote_path :: String.t(),
              local_path :: String.t()
            ) :: {:ok, String.t()} | {:error, term}
end
