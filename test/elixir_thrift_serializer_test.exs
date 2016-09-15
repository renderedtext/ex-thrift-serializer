defmodule ElixirThriftSerializerTest do
  use ExUnit.Case
  doctest ElixirThriftSerializer
  use ElixirThriftSerializer, file: ["exampleonly"], structs: [:User]

  test "serialize and deserialize" do
    user = ElixirThriftSerializerStruct.User.new(name: "Wade Winston Wilson", age: 25)

    binary = elixir_to_binary(user, :User)

    {:ok, debinarized} = binary_to_elixir(binary, :User)

    assert user == %ElixirThriftSerializerTest.ElixirThriftSerializerStruct.User{age: 25,
        name: "Wade Winston Wilson"}

    assert user == debinarized
  end
end
