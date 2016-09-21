defmodule ThriftSerializer do

  defmodule Error do
    defexception message: ""
  end

  defmacro __using__(opts) do
    file_name  = Keyword.get(opts, :file, [])
    structs    = Keyword.get(opts, :structs, [])
    file_types = String.to_atom("#{file_name}_types")

    quote do
      import ThriftSerializer
      use Riffed.Struct, [{unquote(file_types), [unquote_splicing(structs)]}]

      def decode(record_binary, [model: struct_name]) do
        struct_definition = {:struct, {unquote(file_types), struct_name}}

        with {:ok, memory_buffer_transport} <- :thrift_memory_buffer.new(record_binary),
             {:ok, binary_protocol} <- :thrift_binary_protocol.new(memory_buffer_transport),
             {_, {:ok, record}} <- :thrift_protocol.read(binary_protocol, struct_definition),

          do: to_elixir(record, struct_definition) |> Map.delete :__struct__
      end

      def encode(hash, [model: struct_name]) do
        elixir_struct =
          struct_name
          |> apply(:new, [Map.to_list(hash)])
          |> validate!

        struct_definition = {:struct, {unquote(file_types), struct}}

        try do
          with {:ok, tf} <- :thrift_memory_buffer.new_transport_factory(),
               {:ok, pf} <- :thrift_binary_protocol.new_protocol_factory(tf, []),
               {:ok, binary_protocol} <- pf.()
            do
              {proto, :ok} =
                to_erlang(elixir_struct, struct_definition)
                |> write_proto(binary_protocol, struct_definition)

              {_, data} = :thrift_protocol.flush_transport(proto)
              :erlang.iolist_to_binary(data)
            end

        rescue ArgumentError -> raise Error, message: "Invalid field type" end
      end

      defp write_proto(thrift_struct, protocol, struct_definition) do
        :thrift_protocol.write(protocol, {struct_definition, thrift_struct})
      end

      defp validate!(struct) do
        case (Map.values(struct) |> Enum.any?(&(&1 == :undefined))) do
          true  -> raise Error, message: "Required field is missing"
          false -> struct
        end
      end

      defp to_module_name(struct_name) do
        top_module = String.replace("#{__MODULE__}", "Elixir.", "")
        # IO.inspect top_module

        "#{top_module}.#{Atom.to_string(struct_name)}"
        # |> String.replace([".Elixir", "Elixir."], "")
        # |> IO.inspect
        |> String.to_atom
      end
    end
  end
end
