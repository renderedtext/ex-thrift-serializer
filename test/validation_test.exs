defmodule ValidationTest do
  use ExUnit.Case

  test "Validate hash fields types" do
    user = Structs.User.new(name: "Wade", age: "25")

    assert_raise(ThriftSerializer.Error, fn -> Structs.encode(user, :User) end)
  end

  test "Validate required hash fields" do
    user = Structs.User.new(name: "Wade")

    assert_raise(ThriftSerializer.Error, fn -> Structs.encode(user, :User) end)
  end

end
