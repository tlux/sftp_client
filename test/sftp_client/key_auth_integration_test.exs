defmodule SFTPClient.KeyAuthIntegrationTest do
  use SFTPClient.IntegrationCase

  alias SFTPClient.Config
  alias SFTPClient.OperationError

  test "connect with RSA key" do
    config =
      Config.new(
        host: "localhost",
        port: 2223,
        user: "foo",
        private_key_path: "test/fixtures/ssh_keys/id_rsa"
      )

    assert {:ok, conn} = SFTPClient.connect(config)
    assert :ok = SFTPClient.disconnect(conn)
  end

  test "connect with RSA key and passphrase"

  test "connect with ED25519 key"

  test "connect with ED25519 key and passphrase"

  test "connect error" do
    config =
      Config.new(
        host: "localhost",
        port: 2224,
        user: "foo",
        password: "s3cret",
        connect_timeout: 500
      )

    assert SFTPClient.connect(config) ==
             {:error, %OperationError{reason: :econnrefused}}
  end
end
