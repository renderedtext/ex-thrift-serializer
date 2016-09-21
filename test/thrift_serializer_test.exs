defmodule ThriftSerializerTest do
  use ExUnit.Case

  test "encode hash to binary" do
    user = %{name: "Wade", age: 25}
    binary = Structs.encode(user, :User)

    assert binary ==
      <<11, 0, 1, 0, 0, 0, 4, 87, 97, 100, 101, 8, 0, 2, 0, 0, 0, 25, 0>>
  end

  test "decode binary to hash" do
    user = Structs.User.new(name: "Wade", age: 25)
    binary = Structs.encode(user, :User)

    assert Structs.decode(binary, :User) == user
  end

end
