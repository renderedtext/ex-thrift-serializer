defmodule ValidationTest do
  use ExUnit.Case

  test "Validate hash fields types" do
    user = %{name: "Wade", age: "25"}

    assert_raise(ThriftSerializer.Error,
                 fn -> Structs.encode(user, [model: Structs.User]) end)
  end

  test "Validate required hash fields" do
    user = %{name: "Wade"}

    assert_raise(ThriftSerializer.Error,
                 fn -> Structs.encode(user, [model: Structs.User]) end)
  end

end
