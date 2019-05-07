defmodule SFTPClient.Adapter do
  alias SFTPClient.Config
  alias SFTPClient.Conn

  @callback connect(Config.t()) :: {:ok, Conn.t()} | {:error, term}

  @callback disconnect(Conn.t()) :: :ok

  @callback list_dir(Conn.t(), path :: String.t()) ::
              {:ok, [String.t()]} | {:error, term}

  @callback read_file(Conn.t(), path :: String.t()) ::
              {:ok, String.t()} | {:error, term}

  @callback file_info(Conn.t(), path :: String.t()) ::
              {:ok, File.Stat.t()} | {:error, term}

  @callback download_file(
              Conn.t(),
              remote_path :: String.t(),
              local_path :: String.t()
            ) :: {:ok, String.t()} | {:error, term}
end
