defmodule ThriftSerializerTest do
  use ExUnit.Case

  test "encode struct to binary" do
    user = Structs.User.new(name: "Wade", age: 25)
    binary = Structs.encode(user, model: Structs.User)

    assert binary ==
      <<11, 0, 1, 0, 0, 0, 4, 87, 97, 100, 101, 8, 0, 2, 0, 0, 0, 25, 0>>
  end

  test "encode struct to binary - 1 argument" do
    user = Structs.User.new(name: "Wade", age: 25)
    binary = Structs.encode(user)

    assert binary ==
      <<11, 0, 1, 0, 0, 0, 4, 87, 97, 100, 101, 8, 0, 2, 0, 0, 0, 25, 0>>
  end

  test "decode binary to struct" do
    user = Structs.User.new(name: "Wade", age: 25)
    binary = Structs.encode(user, model: Structs.User)

    assert Structs.decode(binary, model: Structs.User) == user
  end

end
