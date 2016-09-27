# Elixir Thrift Serializer

[![Build Status](https://semaphoreci.com/api/v1/renderedtext/ex-thrift-serializer/branches/master/badge.svg)](https://semaphoreci.com/renderedtext/ex-thrift-serializer)

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
# thrift/user_service.thrift

struct User {
  1: string name
  2: i32 age
}
```

And the following model definition in our source code:

``` elixir
defmodule UserServiceModels do
  use Riffed.Struct, user_service_types: [:User]
end
```

We can add encoding and decoding by injecting the `use ThriftSerializer` in our
models.

``` elixir
defmodule UserServiceModels do
  use Riffed.Struct, user_service_types: [:User]
  use ThriftSerializer
end
```

### Encoding thrift structures to binary data

``` elixir
user = UserServiceModels.User.new(name: "Wade", age: 25)

UserServideModels.encode(user, model: UserServiceModels.User)
=> <<11, 0, 1, 0, 0, 0, 4, 87, 97, 100, 101, 8, 0, 2, 0, 0, 0, 25, 0>>
```

### Decoding binary data into thrift structures

``` elixir
raw_user = <<11, 0, 1, 0, 0, 0, 4, 87, 97, 100, 101, 8, 0, 2, 0, 0, 0, 25, 0>>

UserServideModels.decode(raw_user, model: UserServideModels.User)
```

### Validation

Models are validates when they are encoded and decoded. If the validation fails,
the `Thriftserializer.Error` is raised.
