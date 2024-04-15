defmodule SFTPClient.KeyAuthIntegrationTest do
  use SFTPClient.IntegrationCase

  alias SFTPClient.Config

  @tag :tmp_dir
  test "upload with private key", %{tmp_dir: tmp_dir} do
    config =
      Config.new(%{
        host: "localhost",
        port: 2223,
        user: "foo",
        private_key_path: "test/fixtures/ssh_keys/id_rsa",
        user_dir: tmp_dir
      })

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
end
