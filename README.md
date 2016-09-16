# Elixir Thrift Serializer

An Elixir app that uses Riffed, which makes life easier for using Thrift with
Elixir, to make life even easier when you want to serialize and deserialize
Thrift structs.

## Installation

Add the following to the list of your dependencies:
```elixir
def deps do
  [
    {:elixir_thrift_serializer, github: "renderedtext/elixir-thrift-serializer"}
  ]
end
```
Also, add it to the list of your applications:
```elixir
def application do
  [applications: [:elixir_thrift_serializer]]
end
```
## Quick usage guide

The following is an example of creating an instance of a Thrift struct called
`User`, which is defined in a file named `thrift/models.thrift`. The instance
is then serialized and deserialized.
```elixir
defmodule TestModule do

  use ElixirThriftSerializer, file: ["models"], structs: [:User]

  def test_function do
    user = ThriftStruct.User.new(name: "Wade Winston Wilson", age: 25)
    serialized = ThriftSerializer.serialize(user, model: :User)
    deserialized = ThriftSerializer.deserialize(serialized, model: :User)
  end

end
```

## Detailed usage guide

<b>IMPORTANT:</b> Make sure to place all your Thrift structs inside a folder
named `thrift`! The app is configured to search for them there.

In order to be as general as possible, Elixir Thrift Serializer doesn't know
about the Thrift structures you are using. You'll need to define them yourself
and, in a way, pass them into the Serializer.<br/>
A Thrift struct should look something like this:
```thrift
struct User {
  1: string name
  2: i32 age
}
```
Lets say that you have defined a struct named `User`, like in the example, and
placed it in a file called `thrift/models.thrift`. In order to use the
Serializer, you would have to write the following line:
```elixir
use ElixirThriftSerializer, file: ["models"], structs: [:User]
```
In the `file` argument pass the name of the file where the structs are
stored and in the `structs` argument pass the names of the structs in the
file you'll be using as atoms. What this does is it defines a new module called
`ThriftSerializerStruct` that can be used to create an instance of a
struct, like this:
```elixir
ThriftSerializerStruct.User.new(name: "Wade Winston Wilson", age: 25)
```
This would be an equivalent of:
```elixir
%ThriftSerializerStruct.User{age: 25, name: "Wade Winston Wilson"}
```
The serialization and deserialization is handled by a module called
`ThriftSerializer`, which is also defined with the `ThriftSerializerStruct`
module. In order to serialize an instance of an `User` struct, do the following:
```elixir
user = ThriftStruct.User.new(name: "Wade Winston Wilson", age: 25)
serialized = ThriftSerializer.serialize(user, model: :User)
```
To deserialize a previously serialized instance, you would do the following:
```elixir
deserialized = ThriftSerializer.deserialize(serialized, model: :User)
```
