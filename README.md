# Elixir Thrift Serializer

Serializer for [riffed](https://github.com/pinterest/riffed).

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

### Setup

For example, if we have the following thrift definition:

``` thrift
# thrift/example_models.thrift

struct User {
  1: string name
  2: i32 age
}
```

And the following model definition in our source code:

``` elixir
defmodule Models do
  use Riffed.Struct, example_models: [:User]
end
```

We can add encoding and decoding by injecting the `use ThriftSerializer` in our
models.

``` elixir
defmodule Models do
  use Riffed.Struct, example_models: [:User]
  use ThriftSerializer
end
```

### Encoding thrift structures to binary data

``` elixir
user = Models.User.new(name: "Wade", age: 25)

Model.encode(user, model: Model.User)
=> <<11, 0, 1, 0, 0, 0, 4, 87, 97, 100, 101, 8, 0, 2, 0, 0, 0, 25, 0>>
```

### Decoding binary data into thrift structures

``` elixir
raw_user = <<11, 0, 1, 0, 0, 0, 4, 87, 97, 100, 101, 8, 0, 2, 0, 0, 0, 25, 0>>

Model.decode(raw_user, model: Model.User)
```

### Validation

Models are validates when they are encoded and decoded. If the validation fails,
the `Thriftserializer.Error` is raised.
