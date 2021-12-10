defmodule Tresmid.Edit do
  require Logger
  @moduledoc """
  Provides functions used in opening the given work tree
  in the configured text editor.
  """
  @moduledoc since: "0.1.0"

  @doc """
  Opens the work tree for the specified repository in the configured
  text editor.
  """
  @doc since: "0.1.0"
  def run(key, ticket) do
    Logger.info("Called edit operation.")
    cache_path = Tresmid.Config.get("cache_path")
    cmd = Tresmid.Config.get("editor")

    {:ok, data} = YamlElixir.read_from_file(cache_path)

    if key in Map.keys(data) do
      wts = data[key]

      branches = wts
      |> Enum.filter(
        fn x ->
          x["ticket"] == ticket
        end
      )

      if length(branches) > 0 do
        branch = Enum.at(branches, 0)
        Logger.debug("Launching text editor for #{ticket}: #{branch["path"]}")
        System.cmd(cmd, [branch["path"]])
      else
        Logger.critical("Invalid Ticket Identifier: #{ticket}")
      end
    else
      Logger.critical("Invalid Repository Key: #{key}")
    end
  end


  ######################### DOCUMENTATION ############################
  @doc false
  def docs do
    """
    ## ed Command

    Tresmid uses the `ed` command to open a work tree for the specified repository
    in a text editor.

    When run, Tresmid uses the specified repository and ticket to locate the worktree
    for that ticket.  It then opens the configured text editor on that directory.

    ```console
    $ tresmid ed <repo> <ticket>
    ```

    The editor can be set using the `editor` configuration variable.  It defaults
    to Visual Studio Code.
    """
  end

  @doc false
  def usage do
    """
    Usage information for ed
    """
  end
end
