defmodule SFTPClient.OperationTest do
  use ExUnit.Case, async: true

  alias SFTPClient.ConnError
  alias SFTPClient.InvalidOptionError
  alias SFTPClient.Operation
  alias SFTPClient.OperationError

  describe "may_bang!/1" do
    # TODO
    test "return ok on ok" do
      assert Operation.may_bang!(:ok) == :ok
    end

    test "return result on ok tuple" do
      result = "result double"

      assert Operation.may_bang!({:ok, result}) == result
    end

    test "raise error on error tuple" do
      message = "Something went wrong"

      assert_raise RuntimeError, message, fn ->
        Operation.may_bang!({:error, %RuntimeError{message: message}})
      end
    end
  end

  describe "handle_error/1" do
    test "invalid option error" do
      error = {:eoptions, {{:user_dir, 'my/key/path'}, :enoent}}

      assert Operation.handle_error(error) == %InvalidOptionError{
               key: :user_dir,
               value: "my/key/path",
               reason: :enoent
             }
    end

    test "invalid option error with non-charlist" do
      error = {:eoptions, {{:another_key, 1337}, :enoent}}

      assert Operation.handle_error(error) == %InvalidOptionError{
               key: :another_key,
               value: 1337,
               reason: :enoent
             }
    end

    test "operation error" do
      reason = :enoent

      assert Operation.handle_error(reason) == %OperationError{reason: reason}
    end

    test "conn error" do
      message = 'Something went wrong'

      assert Operation.handle_error(message) == %ConnError{
               message: to_string(message)
             }
    end
  end
end
