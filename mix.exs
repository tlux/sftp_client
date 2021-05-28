defmodule SFTPClient.MixProject do
  use Mix.Project

  @source_url "https://github.com/tlux/sftp_client"
  @version "1.4.6"

  def project do
    [
      app: :sftp_client,
      version: @version,
      elixir: "~> 1.8",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      test_coverage: [tool: ExCoveralls],
      preferred_cli_env: [
        coveralls: :test,
        "coveralls.detail": :test,
        "coveralls.post": :test,
        "coveralls.html": :test,
        "coveralls.travis": :test
      ],
      dialyzer: [plt_add_apps: [:ex_unit, :mix]],
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
      {:credo, "~> 1.4", only: [:dev, :test], runtime: false},
      {:dialyxir, "~> 1.0", only: [:dev, :test], runtime: false},
      {:excoveralls, "~> 0.13", only: :test},
      {:ex_doc, ">= 0.0.0", only: :dev, runtime: false},
      {:mox, "~> 1.0", only: :test},
      {:temp, "~> 0.4", only: :test}
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
