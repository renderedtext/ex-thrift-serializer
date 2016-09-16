defmodule ElixirThriftSerializerTest do
  use ExUnit.Case
  doctest ElixirThriftSerializer
  use ElixirThriftSerializer, file: ["exampleonly"], structs: [:User]

  test "serialize and deserialize" do
    user = ThriftSerializerStruct.User.new(name: "Wade Winston Wilson", age: 25)

    serialized = ThriftSerializer.serialize(user, model: :User)

    deserialized = ThriftSerializer.deserialize(serialized, model: :User)

    assert user == %ElixirThriftSerializerTest.ThriftSerializerStruct.User{age: 25,
        name: "Wade Winston Wilson"}

    assert user == deserialized

  end
end
