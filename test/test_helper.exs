defmodule Structs do
  use ThriftSerializer, file: ["example"], structs: [:User]
end

ExUnit.configure(trace: true)
ExUnit.start()
