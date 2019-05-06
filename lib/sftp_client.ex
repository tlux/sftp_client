defmodule SFTPClient do
  alias SFTPClient.Config
  alias SFTPClient.Session

  @spec adapter() :: module
  def adapter do
    Application.get_env(:sftp_client, :adapter, SFTPClient.Adapters.SFTP)
  end

  @spec connect(Config.t() | Keyword.t()) :: {:ok, Session.t()} | {:error, term}
  def connect(config_or_opts \\ []) do
    config_or_opts
    |> Config.new()
    |> adapter().connect()
  end

  @spec connect!(Config.t() | Keyword.t()) :: Session.t() | no_return
  def connect!(config_or_opts \\ []) do
    case connect(config_or_opts) do
      {:ok, session} -> session
      {:error, error} -> raise error
    end
  end

  @spec disconnect(Session.t()) :: :ok
  def disconnect(%Session{} = session) do
    adapter().disconnect(session)
  end

  def read_file(%Session{} = session, path) do
    adapter().read_file(session, path)
  end
end
