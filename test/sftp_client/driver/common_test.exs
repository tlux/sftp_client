defmodule SFTPClient.Driver.CommonTest do
  use ExUnit.Case, async: true

  alias SFTPClient.Driver.Common, as: CommonDriver

  describe "run/3" do
    test "delegate to Kernel.apply/3" do
      args = ["arg1", "arg2", "arg3"]

      assert CommonDriver.run(__MODULE__, :my_fun, args) == {:ok, args}
    end
  end

  def my_fun(arg1, arg2, arg3) do
    {:ok, [arg1, arg2, arg3]}
  end
end
