defmodule SFTPClient.Driver do
  @moduledoc """
  A behavior that can be implemented by your own modules to mock or stub SFTP
  operations. You can set a custom driver by specifying it in your config:

      config :sftp_client, :driver, MySFTPMock

  The default driver is `SFTPClient.Driver.Common`.
  """

  alias SFTPClient.Config
  alias SFTPClient.Conn
  alias SFTPClient.Handle

  @callback close_handle(Handle.t()) :: :ok | {:error, SFTPClient.error()}

  @callback close_handle!(Handle.t()) :: :ok | no_return

  @callback connect(Config.t() | Keyword.t() | %{optional(atom) => any}) ::
              {:ok, Conn.t()} | {:error, term}

  @callback connect(
              Config.t() | Keyword.t() | %{optional(atom) => any},
              (Conn.t() -> res)
            ) :: {:ok, res} | {:error, SFTPClient.error()}
            when res: var

  @callback connect!(Config.t() | Keyword.t() | %{optional(atom) => any}) ::
              Conn.t() | no_return

  @callback connect!(
              Config.t() | Keyword.t() | %{optional(atom) => any},
              (Conn.t() -> res)
            ) :: res | no_return
            when res: var

  @callback delete_dir(Conn.t(), Path.t()) :: :ok | {:error, SFTPClient.error()}

  @callback delete_dir!(Conn.t(), Path.t()) :: :ok | no_return

  @callback delete_file(Conn.t(), Path.t()) ::
              :ok | {:error, SFTPClient.error()}

  @callback delete_file!(Conn.t(), Path.t()) :: :ok | no_return

  @callback disconnect(Conn.t()) :: :ok

  @callback download_file(Conn.t(), Path.t(), Path.t()) ::
              {:ok, Path.t()} | {:error, SFTPClient.error()}

  @callback download_file!(Conn.t(), Path.t(), Path.t()) :: Path.t() | no_return

  @callback file_info(Conn.t(), Path.t()) ::
              {:ok, File.Stat.t()} | {:error, SFTPClient.error()}

  @callback file_info!(Conn.t(), Path.t()) :: File.Stat.t() | no_return

  @callback link_info(Conn.t(), Path.t()) ::
              {:ok, File.Stat.t()} | {:error, SFTPClient.error()}

  @callback link_info!(Conn.t(), Path.t()) :: File.Stat.t() | no_return

  @callback list_dir(Conn.t(), Path.t()) ::
              {:ok, [String.t()]} | {:error, SFTPClient.error()}

  @callback list_dir!(Conn.t(), Path.t()) :: [String.t()] | no_return

  @callback make_dir(Conn.t(), Path.t()) :: :ok | {:error, SFTPClient.error()}

  @callback make_dir!(Conn.t(), Path.t()) :: :ok | no_return

  @callback make_link(Conn.t(), Path.t(), Path.t()) ::
              :ok | {:error, SFTPClient.error()}

  @callback make_link!(Conn.t(), Path.t(), Path.t()) :: :ok | no_return

  @callback open_dir(Conn.t(), Path.t()) ::
              {:ok, Handle.t()} | {:error, SFTPClient.error()}

  @callback open_dir(Conn.t(), Path.t(), (Handle.t() -> res)) ::
              {:ok, res} | {:error, SFTPClient.error()}
            when res: var

  @callback open_dir!(Conn.t(), Path.t()) :: Handle.t() | no_return

  @callback open_dir!(Conn.t(), Path.t(), (Handle.t() -> res)) ::
              res | no_return
            when res: var

  @callback open_file(Conn.t(), Path.t(), [SFTPClient.access_mode()]) ::
              {:ok, Handle.t()} | {:error, SFTPClient.error()}

  @callback open_file(
              Conn.t(),
              Path.t(),
              [SFTPClient.access_mode()],
              (Handle.t() -> res)
            ) :: {:ok, res} | {:error, SFTPClient.error()}
            when res: var

  @callback open_file!(Conn.t(), Path.t(), [SFTPClient.access_mode()]) ::
              Handle.t() | no_return

  @callback open_file!(
              Conn.t(),
              Path.t(),
              [SFTPClient.access_mode()],
              (Handle.t() -> res)
            ) :: res | no_return
            when res: var

  @callback read_file_chunk(Handle.t(), non_neg_integer) ::
              {:ok, String.t()} | :eof | {:error, SFTPClient.error()}

  @callback read_file_chunk!(Handle.t(), non_neg_integer) ::
              String.t() | :eof | no_return

  @callback read_file(Conn.t(), Path.t()) ::
              {:ok, binary} | {:error, SFTPClient.error()}

  @callback read_file!(Conn.t(), Path.t()) :: binary | no_return

  @callback read_link(Conn.t(), Path.t()) ::
              {:ok, Path.t()} | {:error, SFTPClient.error()}

  @callback read_link!(Conn.t(), Path.t()) :: Path.t() | no_return

  @callback rename(Conn.t(), Path.t(), Path.t()) ::
              :ok | {:error, SFTPClient.error()}

  @callback rename!(Conn.t(), Path.t(), Path.t()) :: :ok | no_return

  @callback stream_file(Conn.t(), Path.t()) ::
              {:ok, SFTPStream.t()} | {:error, SFTPClient.error()}

  @callback stream_file(Conn.t(), Path.t(), non_neg_integer) ::
              {:ok, SFTPStream.t()} | {:error, SFTPClient.error()}

  @callback stream_file!(Conn.t(), Path.t()) :: SFTPStream.t()

  @callback stream_file!(Conn.t(), Path.t(), non_neg_integer) :: SFTPStream.t()

  @callback upload_file(Conn.t(), Path.t(), Path.t()) ::
              {:ok, Path.t()} | {:error, SFTPClient.error()}

  @callback upload_file!(Conn.t(), Path.t(), Path.t()) :: Path.t() | no_return

  @callback write_file_chunk(Handle.t(), binary) ::
              :ok | {:error, SFTPClient.error()}

  @callback write_file_chunk!(Handle.t(), binary) :: :ok | no_return

  @callback write_file(Conn.t(), Path.t(), binary | [binary]) ::
              :ok | {:error, SFTPClient.error()}

  @callback write_file!(Conn.t(), Path.t(), binary | [binary]) ::
              :ok | no_return
end
