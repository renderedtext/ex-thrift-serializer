defmodule ThriftSerializerTest do
  use ExUnit.Case
  use ThriftSerializer, file: ["example"], structs: [:User]

  test "serialize and deserialize" do
    user = Structs.User.new(name: "Wade Winston Wilson", age: 25)

    serialized = serialize(user, model: :User)

    {:ok, deserialized} = deserialize(serialized, model: :User)

    assert user == %ThriftSerializerTest.Structs.User{age: 25,
        name: "Wade Winston Wilson"}

    assert user == deserialized

  end
end
