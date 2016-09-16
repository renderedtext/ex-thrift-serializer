defmodule ElixirThriftSerializerTest do
  use ExUnit.Case
  doctest ElixirThriftSerializer
  #use ElixirThriftSerializer, file: ["exampleonly"], structs: [:User]

  defmodule ElixirThriftSerializerStruct do
    use Riffed.Struct, exampleonly_types: [:User]
  end

  test "serialize and deserialize" do

    user = ElixirThriftSerializerStruct.User.new(name: "Wade Winston Wilson", age: 25)

    serialized = ElixirThriftSerializer.serialize(user, [{:model, :User}], "exampleonly", ElixirThriftSerializerStruct)

    deserialized = ElixirThriftSerializer.deserialize(serialized, [{:model, :User}], "exampleonly", ElixirThriftSerializerStruct)

    assert user == %ElixirThriftSerializerTest.ElixirThriftSerializerStruct.User{age: 25,
        name: "Wade Winston Wilson"}

    assert user == deserialized

  end
end
