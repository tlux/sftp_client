defmodule SFTPClient.SSHXferAttr do
  @moduledoc """
  A struct that contains file and directory meta data.
  """

  require Record

  record = Record.extract(:ssh_xfer_attr, from_lib: "ssh/src/ssh_xfer.hrl")
  keys = :lists.map(&elem(&1, 0), record)
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
