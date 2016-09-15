# Elixir Thrift Serializer

An Elixir app that uses Riffed, which makes life easier for using Thrift with
Elixir, to make life even easier when you want to serialize and deserialize
Thrift structs.

## Installation

Add the following to the list of your dependencies:
```elixir
def deps do
  [
    {:elixir-thrift-serializer, github: "renderedtext/elixir-thrift-serializer"}
  ]
end
```
Also, add it to the list of your applications:
```elixir
def application do
  [applications: [:elixir-thrift-serializer]]
end
```

## Usage

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
`ElixirThriftSerializerStruct` that can be used to create an instance of a
struct, like this:
```elixir
ElixirThriftSerializerStruct.User.new(name: "Wade Winston Wilson", age: 25)
```
This would be an equivalent of:
```elixir
%ElixirThrift.Struct.User{age: 25, name: "Wade Winston Wilson"}
```
In order to serialize an instance of an `User` struct, do the following:
```elixir
user = ElixirThriftStruct.User.new(name: "Wade Winston Wilson", age: 25)
serialized = serialize(user, :User)
```
To deserialize a previously serialized instance, you would do the following:
```elixir
{:ok, deserialized} = deserialize(serialized, :User)
```
