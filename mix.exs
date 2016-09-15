defmodule ElixirThriftSerializer.Mixfile do
  use Mix.Project

  def project do
    [app: :elixir_thrift_serializer,
     version: "0.1.0",
     elixir: "~> 1.3",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     compilers: [:thrift | Mix.compilers],
     thrift_files: Mix.Utils.extract_files(["thrift"], [:thrift]),
     deps: deps()]
  end

  def application do
    [applications: [:logger,
        :riffed
    ]]
  end

  defp deps do
    [{:riffed, github: "pinterest/riffed", tag: "1.0.0", submodules: true}]
  end
end
