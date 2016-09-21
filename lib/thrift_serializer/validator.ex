defmodule ThriftSerializer.Validator do

  def validate!(struct) do
    if (Map.values(struct) |> Enum.any?(&(&1 == :undefined))) do
      raise ThriftSerializer.Error, message: "Required field is missing"
    end
  end

end
