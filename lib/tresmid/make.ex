defmodule Tresmid.Make do
  require Logger

  @moduledoc """
  Provides functions used in creating work trees from the given repository.
  """
  @moduledoc since: "0.1.0"

  @doc """
  Creates a new work tree branch for the given repository.
  """
  @doc since: "0.1.0"
  def run(key, branch, upstream) do
    Logger.info("Called make operation.")

    repos = Tresmid.Config.get("repos")
    data = Tresmid.Config.read_cache()

    if key in Map.keys(data) do
      repo = data[key]
      conf = repos[key]

      main = Tresmid.Config.get_main(repo, conf)

      if main != nil do
        git = Git.new(main["path"])
        wt_path = Path.join(Path.dirname(main["path"]), branch)
        if !File.exists?(wt_path) do
          Git.worktree(git, ["add", "--track", "-b", branch, wt_path, upstream])
        else
          Logger.critical("Target path exists: #{wt_path}")
        end

        Tresmid.Update.run
      else
        Logger.critical("Unable to locate #{conf["main"]} branch in #{key}")
      end
    else
      Logger.critical("Invalid repository key: #{key}")
    end
  end

  ######################## DOCUMENTATION ############################
  @doc false
  def docs do
    """
    ## mk Command

    Tresmid uses the `mk` command to create a work tree from the given repository.
    """
  end

  @doc false
  def usage do
    """
    Usage function for mk
    """
  end
end
