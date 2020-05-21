defmodule SFTPClient.KeyProviderTest do
  use ExUnit.Case

  alias SFTPClient.KeyProvider

  describe "user_key/2" do
    test "RSA key" do
      assert {:ok, _} =
               KeyProvider.user_key(:"ssh-rsa",
                 key_cb_private: [
                   private_key_path: "test/fixtures/ssh_keys/id_rsa"
                 ]
               )
    end

    test "RSA key with passphrase"

    test "ED25519 key"

    test "ED25519 key with passphrase"
  end
end
