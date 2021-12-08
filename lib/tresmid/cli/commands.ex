defmodule Tresmid.CLI.Commands do
  require Logger
  @moduledoc """

  Commands and arguments used by the Tresmid CLI application.

  |Command | Description |
  |---|---|
  | `config` | Used to manage global configuration options. |
  | `remote` | Used to configure remotes for local Git repositories. |
  | `repo` | Used to configure local Git repositories. |

  #{Tresmid.Config.docs}

  #{Tresmid.Remote.docs}

  #{Tresmid.Repo.docs}
  """

  def cwd(path) do
    case path do
      nil -> Path.expand(File.cwd())
      _ -> Path.expand(path)
    end
  end

  def docs do
    [
      {"config", "Sets global configuration."},
      {"remote", "Manages remotes for repository home"},
      {"repo", "Configures directory to operate as a repository home."},
      {"help", "Provides usage information."}
    ]
  end

  def help(cmd) do
    "\n\tSee tresmid #{cmd} help for additional information."
  end

  ################## CONFIGURATION COMMANDS ####################

  # Getter and Setter
  def run({opts, ["config", sub | rest]}) do
    Tresmid.Database.start_link(opts[:verbose])

    case sub do
      "get" ->
        [var | _ ] = rest
        Tresmid.Config.get(var)
      "set" ->
        [var, val | _] = rest
        Tresmid.Config.set(var, val)
      "init" ->
        Tresmid.Config.init
      "dump" ->
        Tresmid.Config.dump
      "help" ->
        IO.puts(Tresmid.Config.usage)
      true ->
        IO.puts("Invalid config Sub-command: #{sub}#{help("config")}", :stderr)
    end
  end

  # Default Config
  def run({opts, ["config"]}) do
  end

  ################## REMOTE COMMANDS ###########################
  def run({opts, ["remote" | args]}) do
    Tresmid.Database.start_link(opts[:verbose])

    case args do
      ["add", repo, remote, url] -> Tresmid.Remote.add(repo, remote, url)
      ["drop", repo, remote] -> Tresmid.Remote.drop(repo, remote)
      [repo] -> Tresmid.Remote.list(repo)
      [] -> Tresmid.Remote.list
      _ -> IO.puts("Invalid remote Arguments: #{Enum.join(args, " ")}")
    end
  end

  ################### REPO COMMANDS ############################
  def run({opts, ["repo"| args]}) do
    Tresmid.Database.start_link(opts[:verbose])
    case args do
      ["add", repo] -> Tresmid.Repo.add(repo)
      ["dump", repo ] -> Tresmid.Repo.dump(repo)
      ["get", repo, var] -> Tresmid.Repo.get(repo, var)
      ["set", repo, var, val] -> Tresmid.Repo.set(repo, var, val)
      ["drop", repo ] -> Tresmid.Repo.drop(repo)
      ["init", repo] -> Tresmid.Repo.init(repo)
      [] -> Tresmid.Repo.list()
      _ ->
        IO.puts("Unknown repo Arguments: #{Enum.join(args, " ")}")
        Tresmid.Repo.usage
    end
  end


  ################### HELP COMMANDS #############################
  def run({opts, args, :help}) do
    Logger.info("Called help operation.")
    Tresmid.CLI.Docs.usage
  end

  def run({opts, args}) do
    Logger.info("Called no operation, defaulting to help.")
    Tresmid.CLI.Docs.usage
  end
end
