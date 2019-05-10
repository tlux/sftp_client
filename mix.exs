defmodule SFTPClient.MixProject do
  use Mix.Project

  def project do
    [
      app: :sftp_client,
      version: "1.2.0",
      elixir: "~> 1.8",
      start_permanent: Mix.env() == :prod,
      description: description(),
      deps: deps(),
      test_coverage: [tool: ExCoveralls],
      preferred_cli_env: [
        coveralls: :test,
        "coveralls.detail": :test,
        "coveralls.post": :test,
        "coveralls.html": :test
      ],
      package: package(),
      elixirc_paths: elixirc_paths(Mix.env()),

      # Docs
      name: "SFTP Client",
      source_url: "https://github.com/i22-digitalagentur/sftp_client",
      docs: [
        main: "SFTPClient",
        extras: ["README.md"],
        groups_for_modules: [
          "Adapter Behaviors": [
            SFTPClient.Adapter.SFTP,
            SFTPClient.Adapter.SSH
          ],
          Drivers: [
            SFTPClient.Driver,
            SFTPClient.Driver.Common
          ],
          Operations: [
            SFTPClient.OperationUtil,
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
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger, :ssh]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:excoveralls, "~> 0.11.0", only: :test},
      {:ex_doc, "~> 0.20.2", only: :dev},
      {:mox, "~> 0.5.0", only: :test},
      {:temp, "~> 0.4", only: :test}
    ]
  end

  defp description do
    "An Elixir SFTP Client that wraps Erlang's ssh and ssh_sftp."
  end

  defp package do
    [
      licenses: ["MIT"],
      links: %{
        "Source" => "https://github.com/i22-digitalagentur/sftp_client"
      }
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]
end
