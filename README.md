# Elixir Thrift Serializer

Elixir app based on [riffed](https://github.com/pinterest/riffed), encodes hashes to `thrift` messages and decodes `thrift` messages to hashes. Check out [thrift-serializer](https://github.com/renderedtext/thrift-serializer) for `Ruby`

## Installation

Add the following to the list of your dependencies:

``` elixir
def deps do
  [
    {:thrift_serializer, github: "renderedtext/ex-thrift-serializer"}
  ]
end
```

Also, add it to the list of your applications:

``` elixir
def application do
  [applications: [:thrift_serializer]]
end
```

## Usage

**IMPORTANT:** Make sure to place all your Thrift structs inside a folder
named `thrift`! The app is configured to search for them there.

A Thrift struct should look something like this:

``` thrift
struct User {
  1: required string name
  2: i32 age
}
```

Lets say that you have defined a struct named `User`, like in the example, and
placed it in a file called `thrift/models.thrift`.

First, declare new module:

``` elixir
defmodule Structs do
  use ThriftSerializer, file: ["models"], structs: [:User]
end
```

* `:file` is name of the `.thrift` file in `thrift` folder where are structs you want to use

* `:structs` is a list of structs defined in corresponding `.thrift` file you want to use

For each struct in `:structs` argument new submodule is defined. In an example above it would be: `Structs.User`

You can create new struct:

``` elixir
Structs.User.new(name: "Wade Winston Wilson", age: 25)

# => %Structs.User{name: "Wade Winston Wilson", age: 25}
```

## Encoding

To encode `elixir` struct into binary:

```elixir
user = Structs.User.new(name: "Wade", age: 25)
binary = Structs.encode(user, :User)

# => <<11, 0, 1, 0, 0, 0, 4, 87, 97, 100, 101, 8, 0, 2, 0, 0, 0, 25, 0>>
```

## Decoding

To decode a previously encoded instance, you would do the following:

```elixir
decoded = Structs.decode(binary, :User)

# => %Structs.User{name: "Wade", age: 25}
```

# Model validation

Hashes are validated against corresponding structs defined in `.thrift` file

Exception is raised in case:

* Required field is missing:

``` elixir

user = Structs.User.new(age: 25)  # `name` missing
binary = Structs.encode(user, :User)

# => Raises ThriftSerializer.Error: "Required field is missing"
```

* Invalid struct field type:


``` elixir

user = Structs.User.new(name: "Wade", age: "25")  # `age` should be number
binary = Structs.encode(user, :User)

# => Raises ThriftSerializer.Error: "Invalid field type"
```

Exception is not raised if you try to decode message with invalid struct.
In that particular case `ThriftSerializer` will map any overlapping fields and
log info about fields that can't be mapped.

For example let `.thrift` file contains following structs:

``` thrift
struct User {
  1 : required string name
  2 : required i32 age
}

struct Range {
  1: i32 min
  2: i32 max
}
```

You can do following:

``` elixir
defmodule Structs do
  use ThriftSerializer, file: ["models"], structs: [:User, :Range]
end

user = Structs.User.new(name: "Wade", age: 25)
binary = Structs.encode(user, :User)

decoded = Structs.decode(binary, :Range)

# => %Structs.Range{max: 25, min: nil}
# => [info] Skipped 1 field
```
