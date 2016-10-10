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

      def encode(struct) do
        encode(struct, model: struct.__struct__)
      end

      def encode(struct, [model: model]) do
        {:ok, encode!(struct, [model: model])}
      rescue
        e -> {:error, e}
      catch
        e -> {:error, e}
      end

      def encode!(struct) do
        encode!(struct, model: struct.__struct__)
      end

      def encode!(struct, [model: model]) do
        struct |> ThriftSerializer.Validator.validate!

        ThriftSerializer.Encoder.encode(struct,
                                        struct_name(model, __MODULE__),
                                        thrift_module,
                                        __MODULE__)
      end

      def decode(binary, [model: model]) do
        {:ok, decode!(binary, [model: model])}
      rescue
        e -> {:error, e}
      catch
        e -> {:error, e}
      end

      def decode!(binary, [model: model]) do
        ThriftSerializer.Decoder.decode(binary,
                                        struct_name(model, __MODULE__),
                                        thrift_module,
                                        __MODULE__)
      end

      defp struct_name(model, module) do
        Atom.to_string(model)
        |> String.replace("#{__MODULE__}.", "")
        |> String.to_atom
      end

    end
  end
end
