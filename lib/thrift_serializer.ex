defmodule ThriftSerializer do
  defmacro __using__(options) do
    quote do
      def thrift_module do
        [{module, _}] = @thrift_options

        module
      end

      def thrift_models do
        [{_, models}] = @thrift_options

        models
      end

      def encode(hash, [model: model]) do
        struct =
          apply(model, :new, [Map.to_list(hash)])
          |> validate!

        ThriftSerializer.Encoder.encode(struct,
                                        get_struct_name(model, __MODULE__),
                                        thrift_module)
      end

      def decode(binary, [model: model]) do
        ThriftSerializer.Decoder.decode(binary,
                                        get_struct_name(model, __MODULE__),
                                        thrift_module)
      end
    end

    defp get_struct_name(model, module) do
      Atom.to_string(model)
        |> String.replace("#{__MODULE__}.", "")
        |> String.to_atom
    end

    defp validate!(struct) do
      case (Map.values(struct) |> Enum.any?(&(&1 == :undefined))) do
        true  -> raise Error, message: "Required field is missing"
        false -> struct
      end
    end
  end
end

# example

# defmodule Models do
#   use Riffed.Struct, example_types: [:User]
#   use ThriftSerializer
# end
