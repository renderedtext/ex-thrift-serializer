defmodule Structs do
  use Riffed.Struct, example_types: [:User]
  use ThriftSerializer
end

ExUnit.configure(trace: true)
ExUnit.start()
