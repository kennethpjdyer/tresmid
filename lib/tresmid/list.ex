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
  def run(repos) do
    Logger.info("Called list operation.")

    cache_path = Path.expand(Tresmid.Config.get("cache_path"))

    {:ok, data} = YamlElixir.read_from_file(cache_path)

    keys = if repos == [] or repos == nil do
      Map.keys(data)
    else
      Map.keys(data)
      |> Enum.filter(
        fn x ->
          x in repos
        end
      )
    end

    keys
    |> Enum.map(
      fn key ->

        head = IO.ANSI.green() <> key <> IO.ANSI.reset()
        wts = data[key]
        |> Enum.map(
          fn x ->
            wt = Map.keys(x)
            |> Enum.map(
              fn y ->
                yellow_line(y, x)
              end
            )
            |> Enum.join("\n")

          end
        )
        |> Enum.join("\n\n")

        "#{head}\n#{wts}\n"
      end
    )
    |> Enum.join("\n")
    |> IO.puts

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
