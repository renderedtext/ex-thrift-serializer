defmodule ThriftSerializer.Mixfile do
  use Mix.Project

  def project do
    [app: :thrift_serializer,
     version: "0.1.0",
     elixir: "~> 1.3",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps()]
  end

  def application do
    [applications:
      [:riffed]
    ]
  end

  defp deps do
    [{:riffed, github: "pinterest/riffed", tag: "1.0.0", submodules: true}]
  end
end
