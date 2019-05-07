defmodule SFTPClient.MixProject do
  use Mix.Project

  def project do
    [
      app: :sftp_client,
      version: "1.0.0",
      elixir: "~> 1.8",
      start_permanent: Mix.env() == :prod,
      deps: deps()
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
      {:ex_doc, "~> 0.20.2", only: :dev},
      {:mox, "~> 0.5.0", only: :test}
    ]
  end
end
