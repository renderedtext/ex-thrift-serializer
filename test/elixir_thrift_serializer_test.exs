defmodule ElixirThriftSerializerTest do
  use ExUnit.Case
  doctest ElixirThriftSerializer
  use ElixirThriftSerializer, file: ["exampleonly"], structs: [:User]

  test "serialize and deserialize" do
    user = ElixirThriftSerializerStruct.User.new(name: "Wade Winston Wilson", age: 25)

    serialized = serialize(user, model: :User)

    {:ok, deserialized} = deserialize(serialized, model: :User)

    assert user == %ElixirThriftSerializerTest.ElixirThriftSerializerStruct.User{age: 25,
        name: "Wade Winston Wilson"}

    assert user == deserialized

  end
end
