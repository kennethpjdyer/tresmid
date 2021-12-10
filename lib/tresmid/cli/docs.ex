defmodule Tresmid.CLI.Docs do
  @moduledoc false

  ####################### CONFIGURE OPTIONS ##############################
  def format_opt({short, long, var, help}) do
    "-#{short}, --#{long} #{var}\t #{help}"
  end
  def format_opt({short, long, help}) do
    "-#{short}, --#{long}      \t #{help}"
  end

  def format_cmd({cmd, help}) do
    "  #{cmd}\t#{help}"
  end

  def format_cmd({cmd, _var, help}) do
    "  #{cmd}\t#{help}"
  end

  def opts do
    Tresmid.CLI.Options.docs
    |> Enum.map(
      fn x -> format_opt(x) end
    )
    |> Enum.join("\n")
  end

  def cmds do
    Tresmid.CLI.Commands.docs
    |> Enum.map(
      fn x -> format_cmd(x) end
    )
    |> Enum.join("\n")
  end

  @doc """
  Prints usage information to stdout.
  """
  @doc since: "0.1.0"
  def usage do
    [
      "Tresmid (from trésmiðr) - A Tool for Git Worktrees\n",
      "tresmid [OPTIONS] COMMAND\n",
      "Options:",
      opts(),
      "",
      "Commands:",
      cmds()

    ]
    |> Enum.join("\n")
    |> IO.puts
  end

  def usage(arg) do
    usage()
  end
end
