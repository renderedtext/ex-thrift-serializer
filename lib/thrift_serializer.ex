defmodule ThriftSerializer do

  defmodule Error do
    defexception message: ""
  end

  defmacro __using__(_options) do
    quote do
      def thrift_module do
        [{module, _}] = @thrift_options

        module
      end

      def encode(hash, [model: model]) do
        struct =
          apply(model, :new, [Map.to_list(hash)])
          |> ThriftSerializer.Validator.validate!

        ThriftSerializer.Encoder.encode(struct,
                                        get_struct_name(model, __MODULE__),
                                        thrift_module,
                                        __MODULE__)
      end

      def decode(binary, [model: model]) do
        ThriftSerializer.Decoder.decode(binary,
                                        get_struct_name(model, __MODULE__),
                                        thrift_module,
                                        __MODULE__)
      end

      defp get_struct_name(model, module) do
        Atom.to_string(model)
        |> String.replace("#{__MODULE__}.", "")
        |> String.to_atom
      end

    end
  end
end
