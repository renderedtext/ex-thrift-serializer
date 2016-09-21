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

      def encode(hash, model) do
        ThriftSerializer.Encoder.encode(hash,
                                        model,
                                        thrift_module,
                                        thrift_models,
                                        __MODULE__)
      end

      def decode(binary, model) do
        ThriftSerializer.Decoder.decode(hash,
                                        model,
                                        thrift_module,
                                        thrift_models,
                                        __MODULE__)
      end
    end
  end
end

# example

# defmodule Models do
#   use Riffed.Struct, example_types: [:User]
#   use ThriftSerializer
# end
