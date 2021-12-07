defmodule Tresmid.Repos do
  @moduledoc """
  Provides functions for configuration and interaction with Git repositories.
  """

  ##################### COMMAND-LINE FUNCTIONS ####################

  @doc since: "0.1.0"
  def add(repo, cwd) do
  end

  @doc since: "0.1.0"
  def dump(repo) do
  end
  def dump do
  end

  @doc since: "0.1.0"
  def drop(repo) do
  end

  @doc since: "0.1.0"
  def get(repo, var) do
  end

  @doc since: "0.1.0"
  def set(repo, var, val) do
  end

  ######################### DOCUMENTATION FUNCTIONS ###########################
  @doc false
  def docs do
    """
    #### repo

    /* TODO: Provide an introduction to the repo command. Note that the repo
    command is designed to configure a repository rather than interact with it.*/

    /* TODO: Note the default behavior.

    * `tresmid repo` lists configured repositories.
    * `tresmid repo <name>` provides basic status information.
    */

    | Sub-Command | Description |
    |---|---|
    | `add` | Adds a repository document with a default configuration to MongoDB. |
    | `dump` | Prints the repository configuration to stdout. |
    | `drop`| Removes a repository document from MongoDB. |
    | `get` | Retrieves the value of a repository configuration option. |
    | `set` | Sets a value on the given repository configuration variable. |

    """
  end

  @doc false
  def usage do
    "Usage text for the repo command has not yet been implemented."
  end

end
