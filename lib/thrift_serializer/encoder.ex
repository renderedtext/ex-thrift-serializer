defmodule ThriftSerializer.Encoder do

  def encode(struct, model, thrift_module, module) do
    struct_definition = {:struct, {thrift_module, model}}

    try do
      erlang_struct = apply(module, :to_erlang, [struct, struct_definition])

      {proto, :ok} =
        :thrift_protocol.write(binary_protocol, {struct_definition, erlang_struct})

      {_, data} = :thrift_protocol.flush_transport(proto)
      :erlang.iolist_to_binary(data)

    rescue ArgumentError ->
      raise ThriftSerializer.Error, message: "Invalid field type"
    end
  end

  defp binary_protocol do
    {:ok, tf} = :thrift_memory_buffer.new_transport_factory()
    {:ok, pf} = :thrift_binary_protocol.new_protocol_factory(tf, [])
    {:ok, binary_protocol} = pf.()

    binary_protocol
  end

end
