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
    :dsa_pass_phrase,
    :rsa_pass_phrase,
    :ecdsa_pass_phrase,
    :private_key_path,
    :private_key_pass_phrase,
    {:inet, :inet},
    :sftp_vsn,
    {:connect_timeout, 5000},
    {:operation_timeout, :infinity}
  ]

  @type t :: %__MODULE__{
          host: String.t(),
          port: non_neg_integer,
          user: String.t(),
          password: nil | String.t(),
          user_dir: nil | Path.t(),
          system_dir: nil | Path.t(),
          dsa_pass_phrase: nil | String.t(),
          rsa_pass_phrase: nil | String.t(),
          ecdsa_pass_phrase: nil | String.t(),
          private_key_path: nil | Path.t(),
          private_key_pass_phrase: nil | String.t(),
          inet: :inet | :inet6,
          sftp_vsn: integer,
          connect_timeout: timeout,
          operation_timeout: timeout
        }

  @doc """
  Builds a config from the given `SFTPClient.Config` struct, keyword list or
  map.
  """
  @spec new(t | Keyword.t() | %{optional(atom) => any}) :: t
  def new(config_or_opts)
  def new(%__MODULE__{} = config), do: config
  def new(opts), do: struct!(__MODULE__, opts)
end
