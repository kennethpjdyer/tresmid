defmodule Tresmid.CLI.Commands do
  require Logger
  @moduledoc """

  Commands and arguments used by the Tresmid CLI application.

  |Command | Description |
  |---|---|
  | `ed` | Opens the configured text editor in the directory of the given ticket. |
  |`ls` | Lists the available Git worktrees in configured repositories. |
  | `mk` | Creates a new work tree for the specified repository and upstream. |
  | `rm` | Removes a work tree for the specified ticket. |
  | `up` | Updates the work tree cache. |

  #{Tresmid.Edit.docs}

  #{Tresmid.List.docs}

  #{Tresmid.Make.docs}

  #{Tresmid.Remove.docs}

  #{Tresmid.Update.docs}
  """

  @doc false
  def docs do
    [
      {"help", "Provides usage information."}
    ]
  end

  @doc false
  def help(cmd) do
    "\n\tSee tresmid #{cmd} help for additional information."
  end

  ################### HELP COMMANDS #############################
  @doc false
  def run({opts, args, :help}) do
    case args do
      _ -> Tresmid.CLI.Docs.usage
    end
  end

  @doc false
  def run({opts, args}) do
    case args do
      ["up"] -> Tresmid.Update.run
      _ ->
        if Enum.member?(opts, :update) do
          Tresmid.Update.run
        end
        case args do
          ["ed", repo, ticket] -> Tresmid.Edit.run(repo, ticket)
          ["ls" | repos]  -> Tresmid.List.run(repos)
          ["mk", repo, branch, upstream] -> Tresmid.Make.run(repo, branch, upstream)
          ["rm", repo, ticket] -> Tresmid.Remove.run(repo, ticket)
        end
    end
  end
end
