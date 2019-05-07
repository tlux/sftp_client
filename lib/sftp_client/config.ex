defmodule SFTPClient.Config do
  @moduledoc """
  A module containing the connection configuration.
  """

  defstruct [
    :host,
    {:port, 22},
    :user,
    :password,
    :user_dir,
    :system_dir,
    :private_key_path,
    :private_key_passphrase,
    {:inet, :inet},
    :sftp_vsn,
    {:connect_timeout, 5000}
  ]

  @type t :: %__MODULE__{
          host: String.t(),
          port: non_neg_integer,
          user: String.t(),
          password: nil | String.t(),
          user_dir: nil | String.t(),
          system_dir: nil | String.t(),
          private_key_path: nil | String.t(),
          private_key_passphrase: nil | String.t(),
          inet: :inet | :inet6,
          sftp_vsn: integer,
          connect_timeout: :infinity | non_neg_integer
        }

  @doc """
  Builds a config from the given `SFTPClient.Config` struct, keyword list or 
  map.
  """
  @spec new(t | Keyword.t()) :: t
  def new(config_or_opts)
  def new(%__MODULE__{} = config), do: config
  def new(opts), do: struct!(__MODULE__, opts)
end
