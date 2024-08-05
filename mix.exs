defmodule SFTPClient.MixProject do
  use Mix.Project

  @source_url "https://github.com/tlux/sftp_client"
  @version "2.1.0"

  def project do
    [
      app: :sftp_client,
      version: @version,
      elixir: "~> 1.11",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      test_coverage: [tool: ExCoveralls],
      preferred_cli_env: [
        "coveralls.detail": :test,
        "coveralls.github": :test,
        "coveralls.html": :test,
        "coveralls.post": :test,
        coveralls: :test,
        credo: :test,
        dialyzer: :test,
        test: :test
      ],
      dialyzer: dialyzer(),
      package: package(),
      elixirc_paths: elixirc_paths(Mix.env()),

      # Docs
      name: "SFTP Client",
      docs: docs()
    ]
  end

  def application do
    [
      extra_applications: [:logger, :ssh]
    ]
  end

  defp deps do
    [
      {:castore, "~> 1.0", only: :test},
      {:credo, "~> 1.7", only: [:dev, :test], runtime: false},
      {:dialyxir, "~> 1.4", only: [:dev, :test], runtime: false},
      {:excoveralls, "~> 0.18", only: :test},
      {:ex_doc, ">= 0.0.0", only: :dev, runtime: false},
      {:mix_audit, "~> 2.1", only: [:dev, :test]},
      {:mox, "~> 1.1", only: :test},
      {:temp, "~> 0.4", only: :test}
    ]
  end

  defp dialyzer do
    [
      plt_add_apps: [:ex_unit, :mix],
      plt_add_deps: :app_tree,
      plt_file: {:no_warn, "priv/plts/sftp_client.plt"}
    ]
  end

  defp package do
    [
      description:
        "An Elixir SFTP Client that wraps Erlang's ssh and ssh_sftp.",
      maintainers: ["Tobias Casper"],
      licenses: ["MIT"],
      links: %{
        "GitHub" => @source_url
      }
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  defp docs do
    [
      extras: [
        "LICENSE.md": [title: "License"],
        "README.md": [title: "Overview"]
      ],
      main: "readme",
      source_url: @source_url,
      source_ref: "v#{@version}",
      formatters: ["html"],
      groups_for_modules: [
        "Adapter Behaviors": [
          SFTPClient.Adapter.SFTP,
          SFTPClient.Adapter.SSH
        ],
        Operations: [
          SFTPClient.Operations.CloseHandle,
          SFTPClient.Operations.Connect,
          SFTPClient.Operations.DeleteDir,
          SFTPClient.Operations.DeleteFile,
          SFTPClient.Operations.Disconnect,
          SFTPClient.Operations.DownloadFile,
          SFTPClient.Operations.FileInfo,
          SFTPClient.Operations.LinkInfo,
          SFTPClient.Operations.ListDir,
          SFTPClient.Operations.MakeDir,
          SFTPClient.Operations.MakeLink,
          SFTPClient.Operations.OpenDir,
          SFTPClient.Operations.OpenFile,
          SFTPClient.Operations.ReadChunk,
          SFTPClient.Operations.ReadDir,
          SFTPClient.Operations.ReadFile,
          SFTPClient.Operations.ReadLink,
          SFTPClient.Operations.Rename,
          SFTPClient.Operations.StreamFile,
          SFTPClient.Operations.WriteChunk,
          SFTPClient.Operations.WriteFile,
          SFTPClient.Operations.ReadDir,
          SFTPClient.Operations.ReadFileChunk,
          SFTPClient.Operations.WriteFileChunk
        ]
      ]
    ]
  end
end
