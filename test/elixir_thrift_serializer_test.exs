defmodule ElixirThriftSerializerTest do
  use ExUnit.Case
  doctest ElixirThriftSerializer

  defmodule ElixirThriftStruct do
    use Riffed.Struct, exampleonly_types: [:User]
  end

  test "serialize and deserialize" do
    user = ElixirThriftStruct.User.new(name: "Wade Winston Wilson", age: 25)
    binary = ElixirThriftSerializer.elixir_to_binary(user,
        {:struct, {:exampleonly_types, :User}},
        &ElixirThriftStruct.to_erlang/2)

    {:ok, debinarized} = ElixirThriftSerializer.binary_to_elixir(binary,
        {:struct, {:exampleonly_types, :User}},
        &ElixirThriftStruct.to_elixir/2)

    assert user == %ElixirThriftSerializerTest.ElixirThriftStruct.User{age: 25,
        name: "Wade Winston Wilson"}
    
    assert user == debinarized
  end
end
