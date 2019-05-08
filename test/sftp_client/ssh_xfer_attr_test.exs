defmodule SFTPClient.SSHXferAttrTest do
  use ExUnit.Case, async: true

  alias SFTPClient.SSHXferAttr

  describe "from_record/1" do
    test "convert to struct" do
      record =
        {:ssh_xfer_attr, :regular, 1_437_729, 12084, 12084, 33188,
         1_557_265_537, :undefined, :undefined, :undefined, 1_541_607_008,
         :undefined, :undefined, :undefined, :undefined}

      assert SSHXferAttr.from_record(record) == %SSHXferAttr{
               group: 12084,
               owner: 12084,
               permissions: 33188,
               size: 1_437_729,
               type: :regular,
               acl: nil,
               atime: {{2019, 5, 7}, {21, 45, 37}},
               atime_nseconds: nil,
               attrib_bits: nil,
               createtime: nil,
               createtime_nseconds: nil,
               extensions: nil,
               mtime: {{2018, 11, 7}, {16, 10, 8}},
               mtime_nseconds: nil
             }
    end
  end
end
