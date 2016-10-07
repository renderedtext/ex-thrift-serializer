defmodule ValidationTest do
  use ExUnit.Case

  test "Validate hash fields types - throwing" do
    user = %{name: "Wade", age: "25"}

    assert_raise(ThriftSerializer.Error,
                 fn -> Structs.encode!(user, [model: Structs.User]) end)
  end

  test "Validate hash fields types - non-throwing" do
    user = %{name: "Wade", age: "25"}

    {:error, _reason} = Structs.encode(user, [model: Structs.User])
  end

  test "Validate required hash fields - throwing" do
    user = %{name: "Wade"}

    assert_raise(ThriftSerializer.Error,
                 fn -> Structs.encode!(user, [model: Structs.User]) end)
  end

  test "Validate required hash fields - non-throwing" do
    user = %{name: "Wade"}

    {:error, _reason} = Structs.encode(user, [model: Structs.User])
  end
end
