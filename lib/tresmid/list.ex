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
        IO.inspect data
        Map.keys(data)
      else
        Enum.filter(
          Map.keys(data),
          fn x ->
            x in targets
          end
        )
      end

    IO.inspect keys

    format_data(keys, data, repos)
  end

  def format_data(keys, data, repos) do
    IO.inspect keys

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

        IO.inspect main_repo

        head
      end
    )
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
