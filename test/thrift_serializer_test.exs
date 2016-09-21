defmodule ThriftSerializerTest do
  use ExUnit.Case

  test "encode hash to binary" do
    user = %{name: "Wade", age: 25}
    binary = Structs.encode(user, model: Structs.User)

    assert binary ==
      <<11, 0, 1, 0, 0, 0, 4, 87, 97, 100, 101, 8, 0, 2, 0, 0, 0, 25, 0>>
  end

  test "decode binary to hash" do
    user = %{name: "Wade", age: 25}
    binary = Structs.encode(user, model: Structs.User)

    assert Structs.decode(binary, model: Structs.User) == user
  end

end
