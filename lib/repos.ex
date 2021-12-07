defmodule Tresmid.Repos do
  @moduledoc """
  Provides functions for configuration and interaction with Git repositories.
  """

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
