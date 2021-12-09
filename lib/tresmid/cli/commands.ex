defmodule Tresmid.CLI.Commands do
  require Logger
  @moduledoc """

  Commands and arguments used by the Tresmid CLI application.

  |Command | Description |
  |---|---|

  """

  def cwd(path) do
    case path do
      nil -> Path.expand(File.cwd())
      _ -> Path.expand(path)
    end
  end

  def docs do
    [
      {"help", "Provides usage information."}
    ]
  end

  def help(cmd) do
    "\n\tSee tresmid #{cmd} help for additional information."
  end


  ################### HELP COMMANDS #############################
  def run({opts, args, :help}) do
    case args do
      _ -> Tresmid.CLI.Docs.usage
    end
  end

  def run({opts, args}) do
    # Commands: up ed cd mk rm
    case args do

    end
  end
end
