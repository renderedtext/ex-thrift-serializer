defmodule ThriftSerializer.Encoder do

  def encode(struct, model, thrift_module) do
    struct_definition = {:struct, {thrift_module, model}}

    try do
      with {:ok, tf} <- :thrift_memory_buffer.new_transport_factory(),
           {:ok, pf} <- :thrift_binary_protocol.new_protocol_factory(tf, []),
           {:ok, binary_protocol} <- pf.()
        do
          {proto, :ok} =
            to_erlang(struct, struct_definition)
            |> write_proto(binary_protocol, struct_definition)

          {_, data} = :thrift_protocol.flush_transport(proto)
          :erlang.iolist_to_binary(data)
        end

    rescue ArgumentError -> raise Error, message: "Invalid field type" end
  end

  defp write_proto(erlang_struct, protocol, struct_definition) do
    :thrift_protocol.write(protocol, {struct_definition, erlang_struct})
  end

end
