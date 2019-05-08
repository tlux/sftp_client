defmodule SFTPClient.DriverTest do
  use ExUnit.Case, async: false

  import Mox

  alias SFTPClient.Driver
  alias SFTPClient.Driver.Common, as: CommonDriver
  alias SFTPClient.Driver.Mock, as: MockDriver

  setup :verify_on_exit!

  setup do
    on_exit(fn ->
      Application.delete_env(:sftp_client, :driver)
    end)

    :ok
  end

  describe "driver/0" do
    test "driver from config" do
      Application.put_env(:sftp_client, :driver, MockDriver)

      assert Driver.driver() == MockDriver
    end

    test "default driver" do
      Application.delete_env(:sftp_client, :driver)

      assert Driver.driver() == CommonDriver
    end
  end

  describe "run/3" do
    test "delegate to driver" do
      Application.put_env(:sftp_client, :driver, MockDriver)

      module = FakeModule
      fun = :fake_fun
      args = ["arg1", "arg2", "arg3"]
      result = {:ok, "result stub"}

      expect(MockDriver, :run, fn ^module, ^fun, ^args -> result end)

      assert Driver.run(module, fun, args) == result
    end
  end
end
