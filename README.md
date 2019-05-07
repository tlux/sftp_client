# SFTP Client

An Elixir SFTP Client that wraps around Erlang's
[ssh](http://erlang.org/doc/man/ssh.html) and
[ssh_sftp](http://erlang.org/doc/man/ssh_sftp.html).

## Prerequisites

* Erlang 20 or greater (at least 21.2 with
  [ssh 4.7.2](http://erlang.org/doc/apps/ssh/notes.html#ssh-4.7.2) recommended
  for ed25519 and ed448 key support)
* Elixir 1.8 or greater

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `sftp_client` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:sftp_client, "~> 1.0.0"}
  ]
end
```

## Docs

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/sftp_client](https://hexdocs.pm/sftp_client).
