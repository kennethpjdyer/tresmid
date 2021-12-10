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
      {"ed", "REPO TICKET", "Opens a text editor on the specified work tree."},
      #{"help CMD", "Provides usage information."},
      {"ls", "[REPO...]", "Lists the current worktrees for the configured repositories."},
      {"mk", "REPO BRANCH UPSTREAM", "Creates a worktree off the specified repository."},
      {"rm", "REPO TICKET", "Removes a worktree from the specified repository."},
      {"up", "Updates the worktree cache for each repository."}
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
      ["ed"| _] -> Tresmid.CLI.Docs.usage(:ed)
      ["ls"| _] -> Tresmid.CLI.Docs.usage(:ls)
      ["mk"| _] -> Tresmid.CLI.Docs.usage(:mk)
      ["rm"| _] -> Tresmid.CLI.Docs.usage(:rm)
      ["up"| _] -> Tresmid.CLI.Docs.usage(:up)
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
          ["rm", repo | tickets] -> Tresmid.Remove.run(repo, tickets)
          _ -> Tresmid.CLI.Docs.usage
        end
    end
  end
end
