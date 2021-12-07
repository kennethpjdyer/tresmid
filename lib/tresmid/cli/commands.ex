defmodule Tresmid.CLI.Commands do
  require Logger

  def cwd(path) do
    case path do
      nil -> Path.expand(File.cwd())
      _ -> Path.expand(path)
    end
  end

  def docs do
    [
      {"config", "Sets global configuration."},
      {"help", "Provides usage information."}
    ]
  end

  def run({opts, ["config", "dump" | _ignored]}) do
    Logger.info("Called config dump operation")
    Tresmid.Database.Config.dump
  end

  def run({opts, args, :help}) do
    Logger.info("Called help operation.")
    Tresmid.CLI.Docs.usage
  end

  def run({opts, args}) do
    Logger.info("Called no operation, defaulting to help.")
    Tresmid.CLI.Docs.usage
  end
end
