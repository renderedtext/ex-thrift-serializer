defmodule ElixirThriftSerializerTest do
  use ExUnit.Case
  doctest ElixirThriftSerializer

  defmodule ElixirThriftStruct do
    use Riffed.Struct, models_types: [:User]
  end

  test "serialize and deserialize" do
    user = ElixirThriftStruct.User.new(name: "Wade Winston Wilson", age: 25)
    binary = ElixirThriftSerializer.elixir_to_binary(user, {:struct, {:models_types, :User}}, &ElixirThriftStruct.to_erlang/2)
    {:ok, debinarized} = ElixirThriftSerializer.binary_to_elixir(binary, {:struct, {:models_types, :User}}, &ElixirThriftStruct.to_elixir/2)
    IO.inspect user
    IO.inspect debinarized
    assert user == debinarized
  end
end
