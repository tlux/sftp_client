# SFTP Client

An Elixir SFTP Client that wraps around Erlang's
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
    {:sftp_client, "~> 1.0.0"}
  ]
end
```

## Docs

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/sftp_client](https://hexdocs.pm/sftp_client).

## TODOs

* Support for ed25519 and ed448 keys (EdDSA passhrases (Curves 25519 and 448)
  are not yet implemented by Erlang's ssh_file)
