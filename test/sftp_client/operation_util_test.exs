defmodule SFTPClient.OperationUtilTest do
  use ExUnit.Case, async: true

  alias SFTPClient.ConnError
  alias SFTPClient.InvalidOptionError
  alias SFTPClient.OperationError
  alias SFTPClient.OperationUtil

  describe "may_bang!/1" do
    test "return ok on ok" do
      assert OperationUtil.may_bang!(:ok) == :ok
    end

    test "return eof on eof" do
      assert OperationUtil.may_bang!(:eof) == :eof
    end

    test "return result on ok tuple" do
      result = "result double"

      assert OperationUtil.may_bang!({:ok, result}) == result
    end

    test "raise error on error tuple" do
      error = %OperationError{reason: :enoent}

      assert_raise OperationError, Exception.message(error), fn ->
        OperationUtil.may_bang!({:error, error})
      end
    end

    test "raise RuntimeError when error contains no exception" do
      message = "Something went wrong"

      assert_raise RuntimeError, "Unexpected error: #{inspect(message)}", fn ->
        OperationUtil.may_bang!({:error, message})
      end
    end
  end

  describe "handle_error/1" do
    test "invalid option error" do
      error = {:eoptions, {{:user_dir, 'my/key/path'}, :enoent}}

      assert OperationUtil.handle_error(error) == %InvalidOptionError{
               key: :user_dir,
               value: "my/key/path",
               reason: :enoent
             }
    end

    test "invalid option error with non-charlist" do
      error = {:eoptions, {{:another_key, 1337}, :enoent}}

      assert OperationUtil.handle_error(error) == %InvalidOptionError{
               key: :another_key,
               value: 1337,
               reason: :enoent
             }
    end

    test "operation error" do
      reason = :enoent

      assert OperationUtil.handle_error(reason) == %OperationError{
               reason: reason
             }
    end

    test "conn error" do
      message = 'Something went wrong'

      assert OperationUtil.handle_error(message) == %ConnError{
               message: to_string(message)
             }
    end
  end
end
