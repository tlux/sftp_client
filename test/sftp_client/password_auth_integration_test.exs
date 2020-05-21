defmodule SFTPClient.PasswordAuthIntegrationTest do
  use SFTPClient.IntegrationCase

  alias SFTPClient.Config
  alias SFTPClient.OperationError

  test "upload" do
    config =
      Config.new(
        host: "localhost",
        port: 2222,
        user: "foo",
        password: "s3cret"
      )

    store_dir = "files/#{:os.system_time(:millisecond)}"

    assert {:ok, conn} = SFTPClient.connect(config)
    assert :ok = SFTPClient.make_dir(conn, store_dir)

    assert {:ok, _} =
             SFTPClient.upload_file(
               conn,
               "test/fixtures/lorem_ipsum.txt",
               "#{store_dir}/lorem-ipsum.txt"
             )

    assert {:ok, ["lorem-ipsum.txt"]} = SFTPClient.list_dir(conn, store_dir)
    assert :ok = SFTPClient.delete_file(conn, "#{store_dir}/lorem-ipsum.txt")
    assert :ok = SFTPClient.delete_dir(conn, store_dir)
    assert :ok = SFTPClient.disconnect(conn)
  end

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
