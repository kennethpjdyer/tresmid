defmodule Tresmid.Update do
  require Logger
  @moduledoc """
  Provides functions used to manage the update process, ensuring that the
  repository cache is up to date with what is available on the file system.
  """
  @moduledoc since: "0.1.0"

  @doc """
  Updates the local cache, matching tickets to work tree branches in the
  configured repositories.

  This function is run from the command-line:

  ```console
  $ tresmid up
  ```
  """
  @doc since: "0.1.0"
  def run do
    Logger.info("Called update operation.")

    repo_home = Tresmid.Config.get("repo_home")
    cache = Tresmid.Config.get("cache_path")

    yml = Tresmid.Config.get("repos")
    |> Map.to_list
    |> Stream.map(&Task.async(Tresmid.Update, :read_repo, [repo_home, &1]))
    |> Enum.map(&Task.await(&1))
    |> Enum.filter(fn x -> x != nil end)
    |> Stream.map(&Task.async(Tresmid.Update, :format_repo, [&1]))
    |> Enum.map(&Task.await(&1))
    |> Enum.join("\n")

    :ok = File.write(cache, "#{yml}\r\n")
  end

  ########################## HELPER FUNCTIONS ##########################
  @doc """
  Formats work tree data retrieved from Git and returns a string ready
  for writing to a YaML file.
  """
  @doc since: "0.1.0"
  def format_worktree(wts) do
    data = Map.keys(wts)
    |> Enum.map(
      fn x -> "#{x}: #{wts[x]}" end
    )
    |> Enum.join("\n    ")

    "  - #{data}"
  end

  @doc """
  Formats repository data to produce a YaML entry.
  """
  @doc since: "0.1.0"
  def format_repo({key, wts}) do
    data = wts
      |> Stream.map(&Task.async(Tresmid.Update, :format_worktree, [&1]))
      |> Enum.map(&Task.await(&1))
      |> Enum.join("\n")

    "#{key}:\n#{data}"
  end

  @doc """
  Extracts work tree information from configured Git repositories.

  The function then processes the return string to generate a tuple with the key
  and a list with a map for each work tree.
  """
  @doc since: "0.1.0"
  def read_repo(repo_home, {key, conf}) do
    Logger.debug("Reading #{key} repository")
    if Map.has_key?(conf, "name") do
      main = Map.get(conf, "main", "main")
      path = Path.join(Path.join(repo_home, conf["name"]), main)
      repo = Git.new(path)

      case Git.worktree(repo, ["list"]) do
        {:ok, wts} -> {key, process_wts(wts)}
        {:error, reason} ->
          Logger.warn("Error reading worktrees from #{conf["name"]}: #{reason}")
          nil
      end
    else
      nil
    end
  end

  @doc """
  Processes the `git worktree` return text, spliting it into an enumerate
  of work tree lines, then passing these lines off to the `Tresmid.Update.process_wt/1`
  function for further break down.
  """
  @doc since: "0.1.0"
  def process_wts(wts) do
    Regex.split(~r/\r\n|\n/, wts)
    |> Stream.map(&Task.async(Tresmid.Update, :process_wt, [&1]))
    |> Enum.map(&Task.await(&1))
    |> Enum.filter(fn x -> x != nil end)
  end

  @doc """
  Processes an individual work tree line, breaking it down into its
  component parts, then creating a map that notes the branch name,
  ticket name, and path.
  """
  @doc since: "0.1.0"
  def process_wt("") do
    nil
  end

  @doc since: "0.1.0"
  def process_wt(wt) do
    [path, commit, branch] = Regex.split(~r/[ \t]+/, wt)

    {ticket, branch_name} = process_branch(branch)

    %{
      "ticket" => ticket,
      "branch" => String.slice(branch_name, 1..-2),
      "path" => path
    }
  end

  @doc """
  Processes branch names from `git worktree` output,
  to extract the ticket identifier.
  """
  @doc since: "0.1.0"
  def process_branch(branch) when branch in ["[master]", "[main]"] do
    {"master", "[master]"}
  end
  def process_branch(branch) do
    case Regex.split(~r/-/, branch) do
      [comp, num | _] -> {"#{String.slice(comp, 1..-1)}-#{num}", branch}
      _ -> {String.slice(branch, 1..-2), branch}
    end
  end

  ########################### DOCUMENTATION ############################
  @doc false
  def docs do
    """
    ## up Command

    Tresmid uses the `up` command to update the repository cache.

    When run, Tresmid checks each repository for available work trees.  It then
    operates on each repository to determine what work trees are available and
    updates the map with the relevant information, writing the results to the
    cache file.

    ```console
    $ tresmid [OPTIONS] up
    ```

    The cache is written to the configuration directory (`~/.config/tresmid`)
    by default.  You can view the contents of this file using the `cat` command.

    ```console
    $ cat ~/.config/tresmid/cache
    docs:
      - branch: master
        path: /home/user/.tresmid/docs/master
        ticket: master
      - branch: DOCS-1981-update-replication-docs
        path: /home/user/.tresmid/docs/DOCS-1981
        ticket: DOCS-1981
    ```

    Generally, this file should only be edited directly by Tresmid.
    """
  end

  @doc false
  def usage do
    {
      "tresmid [OPTIONS] up\n",
      "Updates the local cache with the local Git worktrees."
    }
  end

  @doc false
  def usage_line do
    {"up", "Updates the local cache of repositories and work trees."}
  end
end
