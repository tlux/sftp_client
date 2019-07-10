# SFTP Client

[![Build Status](https://travis-ci.org/i22-digitalagentur/sftp_client.svg?branch=master)](https://travis-ci.org/i22-digitalagentur/sftp_client)
[![Hex.pm](https://img.shields.io/hexpm/v/sftp_client.svg)](https://hex.pm/packages/sftp_client)

An Elixir SFTP Client that wraps Erlang's
[ssh](http://erlang.org/doc/man/ssh.html) and
[ssh_sftp](http://erlang.org/doc/man/ssh_sftp.html).

## Prerequisites

* Erlang 20 or greater
* Elixir 1.8 or greater

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `sftp_client` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:sftp_client, "~> 1.3"}
  ]
end
```

## Usage

There are bang (!) counterparts for almost all available functions.

### Connect & Disconnect

To open a new connection to an SFTP server:

```elixir
{:ok, conn} = SFTPClient.connect(host: "ftp.myhost.com")
```

Refer to the docs for `SFTPClient.Operations.Connect.connect/1` to find out
all available options.

It is strongly recommended to close a connection after your operations have
completed:

```elixir
SFTPClient.disconnect(conn)
```

For short-lived connections you can also use a function as second argument.
After the function body has run or raises, the connection is automatically
closed.

```elixir
SFTPClient.connect([host: "ftp.myhost.com"], fn conn ->
  # Do something with conn
end)
```

### Download

You can download a file from the server you can use the following function.

```elixir
SFTPClient.download_file(conn, "my/remote/dir/file.jpg", "my/dir/local-file.jpg")
# => {:ok, "my/dir/local-file.jpg"}
```

When the third argument is an existing directory on your file system, the file
is downloaded to a file with the same name as the one on the server.

```elixir
SFTPClient.download_file(conn, "my/remote/dir/image.png", "my/local/dir")
# => {:ok, "my/local/dir/image.png"}
```

It is also possible to use Streams to download data into a file or memory.

```elixir
source_stream = SFTPClient.stream_file!(conn, "my/remote/file.jpg")
target_stream = File.stream!("my/local/file.jpg")

source_stream
|> Stream.into(target_stream)
|> Stream.run()
```

### Upload

To upload are file from the file system you can use the following function.

```elixir
SFTPClient.upload_file(conn, "my/local/dir/file.jpg", "my/remote/dir/file.jpg")
# => {:ok, "my/remote/dir/file.jpg"}
```

You can also use Streams to upload data.

```elixir
source_stream = File.stream!("my/local/file.jpg")
target_stream = SFTPClient.stream_file!(conn, "my/remote/file.jpg")

source_stream
|> Stream.into(target_stream)
|> Stream.run()
```

### List Directory

```elixir
SFTPClient.list_dir(conn, "my/dir")
# => {:ok, ["my/dir/file_1.jpg", "my/dir/file_2.jpg", ...]}
```

### Create Directory

```elixir
SFTPClient.make_dir(conn, "my/new/dir")
```

Note that this operation fails unless the parent directory exists.

### Delete

To delete a file:

```elixir
SFTPClient.delete_file(conn, "my/remote/file.jpg")
```

To delete a directory:

```elixir
SFTPClient.delete(conn, "my/remote/dir")
```

Note that a directory cannot be deleted as long as it still contains files.

### Rename

To delete a file or directory:

```elixir
SFTPClient.rename(conn, "my/remote/file.jpg", "my/remote/new-file.jpg")
```

### File Info

You can retrieve meta data about a file from the server such as file size,
modification time, file permissions, owner and so on.

```elixir
SFTPClient.file_info(conn, "my/remote/file.jpg")
# => {:ok, %File.Stat{...}}
```

Refer to the [`File.Stat`](https://hexdocs.pm/elixir/File.Stat.html) docs for a
list of available file information.


### Symbolic Links

There are also a couple of functions that handle symlinks.

It is possible to get the target of a symlink.

```elixir
SFTPClient.read_link(conn, "my/remote/link.jpg")
# => {:ok, "my/remote/file.jpg"}
```

You can retrieve meta data about symlinks, similar to `file_info/2`.

```elixir
SFTPClient.link_info(conn, "my/remote/link.jpg")
# => {:ok, %File.Stat{...}}
```

And you are able to create symlinks.

```elixir
SFTPClient.make_link(conn, "my/remote/link.jpg", "my/remote/file.jpg")
```

## Docs

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/sftp_client](https://hexdocs.pm/sftp_client).

## Missing Features

* Support for ed25519 and ed448 keys
* Remote TAR creation and extraction
* `:ssh_sftp.write_file_info/3`
