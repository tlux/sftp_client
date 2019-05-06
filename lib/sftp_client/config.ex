defmodule SFTPClient.Config do
  defstruct [
    :host,
    {:port, 22},
    :user,
    :password,
    :user_dir,
    :system_dir,
    :private_key_path,
    :private_key_passphrase,
    {:inet, :inet}
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
          inet: :inet | :inet6
        }

  @spec new(t | Keyword.t()) :: t
  def new(config_or_opts)
  def new(%__MODULE__{} = config), do: config
  def new(opts), do: struct!(__MODULE__, opts)
end
