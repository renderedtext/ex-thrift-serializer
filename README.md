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
  [applications: [:tackle]]
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
Also, you need to define a module, where you will specify which are the structs
you'll be using. For an example, if you would have an `User` struct, inside a
file called `thrift/models.thrift`, you would have something like this:
```elixir
defmodule ElixirThriftStruct do
  use Riffed.Struct, models_types: [:User]
end
```
Note that it says `models_types`. The <i>models</i> part comes from the name of
the file where the Thrift struct is placed.<br/>
Creating an instance of a Thrift struct in Elixir is done like this:
```elixir
ElixirThrift.Struct.User.new(name: "Wade Winston Wilson", age: 25)
```
This would be an equivalent of:
```elixir
%ElixirThrift.Struct.User{age: 25, name: "Wade Winston Wilson"}
```
To serialize a struct called `User`, provided that you defined a module called
`ElixirThriftStruct` like in the example above, you would do the following:
```elixir
user = ElixirThriftStruct.User.new(name: "Wade Winston Wilson", age: 25)
binary = ElixirThriftSerializer.elixir_to_binary(user,
    {:struct, {:models_types, :User}},
    &ElixirThriftStruct.to_erlang/2)
```
To deserialize the previously binarized User struct, you would do the following:
```elixir
{:ok, debinarized} = ElixirThriftSerializer.binary_to_elixir(binary,
    {:struct, {:models_types, :User}},
    &ElixirThriftStruct.to_elixir/2)
```
