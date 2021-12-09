defmodule Tresmid.CLI.Commands do
  require Logger
  @moduledoc """

  Commands and arguments used by the Tresmid CLI application.

  |Command | Description |
  |---|---|
  | `cd` | Changes to the directory of the given ticket. |
  | `ed` | Opens the configured text editor in the directory of the given ticket. |
  | `mk` | Creates a new work tree for the specified repository and upstream. |
  | `rm` | Removes a work tree for the specified ticket. |
  | `up` | Updates the work tree cache. |

  #{Tresmid.ChangeDir.docs}

  #{Tresmid.Edit.docs}

  #{Tresmid.Make.docs}

  #{Tresmid.Remove.docs}

  #{Tresmid.Update.docs}
  """

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
    case args do
      ["ed", repo, ticket] -> Tresmimd.Edit.run(repo, ticket)
      ["cd", repo, ticket] -> Tresmimd.ChangeDir.run(repo, ticket)
      ["up"] -> Tresmid.Update.run
      ["mk", repo, ticket, text, upstream] -> Tresmid.Make.run(repo, ticket, text, upstream)
      ["rm", repo, ticket] -> Tresmid.Remove.run(repo, ticket)
    end
  end
end
