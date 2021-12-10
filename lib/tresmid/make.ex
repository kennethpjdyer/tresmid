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
    cache_path = Tresmid.Config.get("cache_path")
    repos = Tresmid.Config.get("repos")

    {:ok, data} = YamlElixir.read_from_file(cache_path)

    if key in Map.keys(data) do
      repo = data[key]
      conf = repos[key]

      mains =
        repo
        |> Enum.filter(
          fn x ->
            x["branch"] == conf["main"]
          end
        )
      if length(mains) > 0 do
        main = Enum.at(mains, 0)
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
