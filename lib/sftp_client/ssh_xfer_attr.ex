defmodule SFTPClient.SSHXferAttr do
  @moduledoc """
  A struct that contains file and directory meta data.
  """

  # Fields of the `#ssh_xfer_attr{}` record, in the order defined in OTP's
  # `ssh/src/ssh_xfer.hrl`. They are declared here instead of being read with
  # `Record.extract/2` because OTP's `src` directories are not always shipped
  # (e.g. Livebook Desktop or stripped releases), which breaks compilation.
  keys = [
    :type,
    :size,
    :owner,
    :group,
    :permissions,
    :atime,
    :atime_nseconds,
    :createtime,
    :createtime_nseconds,
    :mtime,
    :mtime_nseconds,
    :acl,
    :attrib_bits,
    :extensions
  ]

  values = :lists.map(&{&1, [], nil}, keys)
  pairs = :lists.zip(keys, values)

  defstruct keys

  @timestamp_epoch :calendar.datetime_to_gregorian_seconds(
                     {{1970, 1, 1}, {0, 0, 0}}
                   )

  @type t :: %__MODULE__{
          acl: term,
          atime: :calendar.datetime(),
          atime_nseconds: term,
          attrib_bits: term,
          createtime: :calendar.datetime(),
          createtime_nseconds: term,
          extensions: term,
          group: term,
          mtime: :calendar.datetime(),
          mtime_nseconds: term,
          owner: term,
          permissions: term,
          size: non_neg_integer,
          type: atom
        }

  @doc """
  Converts a record of the `:ssh_xfer_attr` type into this struct.
  """
  @spec from_record(tuple) :: t
  def from_record({:ssh_xfer_attr, unquote_splicing(values)}) do
    opts =
      for {key, value} <- %{unquote_splicing(pairs)} do
        {key, sanitize_value(key, value)}
      end

    struct(__MODULE__, opts)
  end

  defp sanitize_value(_key, :undefined), do: nil
  defp sanitize_value(_key, nil), do: nil

  defp sanitize_value(key, value) when key in [:atime, :mtime, :createtime] do
    timestamp_to_datetime(value)
  end

  defp sanitize_value(_key, value), do: value

  defp timestamp_to_datetime(timestamp) do
    :calendar.gregorian_seconds_to_datetime(timestamp + @timestamp_epoch)
  end
end
