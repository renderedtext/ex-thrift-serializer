defmodule ThriftSerializerTest do
  use ExUnit.Case

  setup do
    user = Structs.User.new(name: "Wade", age: 25)
    binary = <<11, 0, 1, 0, 0, 0, 4, 87, 97, 100, 101, 8, 0, 2, 0, 0, 0, 25, 0>>
    model = [model: Structs.User]

     {:ok, [user: user, binary: binary, model: model]}
  end

  test "encode struct to binary", context do
    assert Structs.encode(context[:user], context[:model]) == context[:binary]
  end

  test "encode struct to binary - 1 argument", context do
    assert Structs.encode(context[:user]) == context[:binary]
  end

  test "decode binary to struct", context do
    assert Structs.decode(context[:binary], context[:model]) == context[:user]
  end

end
