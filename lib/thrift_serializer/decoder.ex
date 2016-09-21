defmodule ThriftSerializer.Decoder do

  def decode(binary, model, thrift_module, module) do
    struct_definition = {:struct, {thrift_module, model}}

    with {:ok, memory_buffer_transport} <- :thrift_memory_buffer.new(binary),
         {:ok, binary_protocol} <- :thrift_binary_protocol.new(memory_buffer_transport),
         {_, {:ok, record}} <- :thrift_protocol.read(binary_protocol, struct_definition),

      do: apply(module, :to_elixir, [record, struct_definition])
          |> Map.delete :__struct__
  end
end
