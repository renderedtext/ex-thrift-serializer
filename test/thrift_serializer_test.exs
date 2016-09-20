defmodule ThriftSerializerTest do
  use ExUnit.Case

  test "Encode hash to binary" do
    user = Structs.User.new(name: "Wade", age: 25)
    binary = Structs.encode(user, :User)

    assert binary ==
      <<11, 0, 1, 0, 0, 0, 4, 87, 97, 100, 101, 8, 0, 2, 0, 0, 0, 25, 0>>
  end

  test "Decode binary to hash" do
    user = Structs.User.new(name: "Wade", age: 25)
    binary = Structs.encode(user, :User)

    {:ok, hash} = Structs.decode(binary, :User)

    assert hash == user
  end

end
