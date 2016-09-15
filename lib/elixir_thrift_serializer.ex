defmodule ElixirThriftSerializer do
  require Logger

  defmacro __using__(opts) do

    file_name = Keyword.get(opts, :file, [])
    structs = Keyword.get(opts, :structs, [])
    file_types = String.to_atom("#{file_name}_types")

    quote do
      import ElixirThriftSerializer
      require Logger

      defmodule ElixirThriftSerializerStruct do
        use Riffed.Struct, [{unquote(file_types), [unquote_splicing(structs)]}]
      end

      def binary_to_elixir(record_binary, struct) do

        struct_definition = {:struct, {unquote(file_types), struct}}

        try do
          with({:ok, memory_buffer_transport} <- :thrift_memory_buffer.new(record_binary),
               {:ok, binary_protocol} <- :thrift_binary_protocol.new(memory_buffer_transport),
               {_, {:ok, record}} <- :thrift_protocol.read(binary_protocol, struct_definition)) do

               {:ok, ElixirThriftSerializerStruct.to_elixir(record, struct_definition)}
          end

        rescue _ ->
            Logger.error "Unable to decode!"
            {:error, :cant_decode}
        end
      end

      def elixir_to_binary(struct_to_binarise, struct) do

          struct_definition = {:struct, {unquote(file_types), struct}}

          with({:ok, tf} <- :thrift_memory_buffer.new_transport_factory(),
              {:ok, pf} <- :thrift_binary_protocol.new_protocol_factory(tf, []),
              {:ok, binary_protocol} <- pf.()) do

                proto = ElixirThriftSerializerStruct.to_erlang(struct_to_binarise, struct_definition)
                |> write_proto(binary_protocol, struct_definition)

                {_, data} = :thrift_protocol.flush_transport(proto)
                :erlang.iolist_to_binary(data)

              end
      end

      defp write_proto(thrift_struct, protocol, struct_definition) do
        {proto, :ok} = :thrift_protocol.write(protocol, {struct_definition, thrift_struct})
        proto
      end

    end
  end

end
