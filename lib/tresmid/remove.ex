defmodule Tresmid.Remove do
  require Logger

  @moduledoc """

  Provides functions used in removing work trees from a local Git repository.
  """
  @moduledoc since: "0.1.0"

  @doc """
  Removes the given ticket branch from the repository.
  """
  @doc since: "0.1.0"
  def run(key, tickets) do
    Logger.info("Called remove operation.")

    repos = Tresmid.Config.get("repos")
    data = Tresmid.Config.read_cache()

    if key in Map.keys(data) do
      repo = data[key]
      conf = repos[key]
      if conf["main"] not in tickets do
        main = Tresmid.Config.get_main(repo, conf)

        if main != nil do
          git = Git.new(main["path"])

          repo
          |> Enum.filter(
            fn x ->
              x["ticket"] in tickets
            end
          )
          |> Enum.map(
            fn x ->
              wpath = x["path"]
              Logger.info("Removing worktree at #{wpath}")
              Git.worktree(
                git,
                ["remove", wpath]
              )
            end
          )
          Tresmid.Update.run()
        else
          Logger.critical("Unable to locate #{conf["main"]} branch")
        end
      else
        Logger.critical("Deletion of the #{conf["main"]} is not permitted.")
      end
    else
      Logger.critical("Invalid repository key: #{key}")
    end
  end

  ########################## DOCUMENTATION ##############################
  @doc false
  def docs do
    """
    ## rm Command

    Tresmid uses the `rm` command to remove a work tree.
    """
  end

  @doc false
  def usage do
    """
    Usage text for rm command.
    """
  end
end
