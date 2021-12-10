defmodule Tresmid.List do
  require Logger
  @moduledoc """

  Provides functions used in listing the available work trees across some
  or all of the configured repositories.
  """
  @moduledoc since: "0.1.0"


  @doc """
  Lists the configured repositories and available worktrees to stdout.

  This function is run from the command-line:

  ```console
  $ tresmid ls
  ```

  When no arguments are passed to this function, it prints a list of the
  available worktrees in all configured repositories.  If a list of repositories
  is passed in, it only prints worktrees from the listed repositories.
  """
  @doc since: "0.1.0"
  def run(targets) do
    Logger.info("Called list operation.")

    repos = Tresmid.Config.get("repos")
    data = Tresmid.Config.read_cache

    Logger.debug("Targets: #{Enum.join(targets, ",")} (#{length(targets)} targets)")

    keys = if length(targets) == 0 do
        Map.keys(data)
      else
        Enum.filter(
          Map.keys(data),
          fn x ->
            x in targets
          end
        )
      end

    format_data(keys, data, repos)
    |> Enum.join("\n")
    |> IO.puts
  end

  def format_data(keys, data, repos) do

    keys
    |> Enum.map(
      fn key ->
        head = IO.ANSI.green() <> key <> IO.ANSI.reset()
        main = repos[key]["main"]

        main_repo =
          data[key]
          |> Enum.filter(
            fn x ->
              x["branch"] == main
            end
          )
          |> Enum.at(0)

        wts =
          data[key]
          |> Enum.filter(
            fn x ->
              x["branch"] != main
            end
          )

      # Format Output
      [
        head,
        format_wt(main_repo)
        |
        wts
        |> Enum.map(fn x -> format_wt(x) end)
      ]
      |> Enum.join("\n")

      end
    )
  end

  @doc """
  Formats work tree data for stdout.
  """
  @doc since: "0.1.0"
  def format_wt(data) do
    path = data["path"]

    fpath = Path.join(
      Path.dirname(path),
      IO.ANSI.yellow()
        <> Path.basename(path)
        <> IO.ANSI.reset())
    "- [ "
    <> IO.ANSI.blue()
    <> data["ticket"]
    <> IO.ANSI.reset()
    <> " ]:    \t#{fpath}"
  end

  @doc """
  Takes given key and data and returns a colored key and value string.
  """
  @doc since: "0.1.0"
  def yellow_line(key, data) do
    "- " <> IO.ANSI.yellow() <> String.capitalize(key) <> IO.ANSI.reset() <> ": " <> data[key]
  end

  ########################## DOCUMENTATION ############################
  @doc false
  def docs do
    """
    ## ls Command

    Tresmid uses the `ls` command to list the available worktrees in either
    all or the specified repositories.

    When run without arguments, Tresmid reads the cache file and then prints
    the information to stdout.  The `ls` command call also take a series of
    keys to filter the results to the specific repositories that interest you.

    ```console
    $ tresmid [OPTIONS] ls [REPO...]
    ```

    Passing the `--update` flag causes Tresmid to update the cache before
    it reads the file.

    """
  end

  @doc false
  def usage do
    ""
  end

end
