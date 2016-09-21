defmodule ThriftSerializer.Validator do

  def validate!(struct) do
    case (Map.values(struct) |> Enum.any?(&(&1 == :undefined))) do
      true  -> raise ThriftSerializer.Error, message: "Required field is missing"
      false -> struct
    end
  end

end
