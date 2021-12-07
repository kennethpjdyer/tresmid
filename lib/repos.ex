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
    | `drop`| Removes a repository document from MongoDB. |
    | `dump` | Prints the repository configuration to stdout. |
    | `get` | Retrieves the value of a repository configuration option. |
    | `set` | Sets a value on the given repository configuration variable. |

    ##### repo add

    Adds a repository document to MongoDB.

    Repositories start out with a default configuration
    set to the current directory.  The configuration is inserted
    as a document in a MongoDB document in the `tresmid.repos`
    collection.  This document requires further configuration to use.

    To further configure the repository, see `repo set`.

    ```console
    $ tresmid repo add example
    ```

    ##### repo drop

    Removes a repository document from MonoDB.

    Repository documents contain the full configuration
    of the repository, as well as all work tree branches added
    to the repository.

    > **Warning**: Dropping a repository configuration is not reversable.

    ```console
    $ tresmid repo drop example
    ```

    ##### repo dump

    Prints the repository configuration to stdout.

    ```console
    $ tresmid repo dump example
    ```

    ##### repo get

    Retrieves the current value of a repository configuration option.

    ```console
    $ tresmid repo get example repo_home
    /home/user/.work-repos/example
    ```

    ##### repo set

    Sets a new value on the specified repository configuration option.

    ```console
    $ tresmid repo set example github_email user@example.com
    ```

    """
  end

  @doc false
  def usage do
    "Usage text for the repo command has not yet been implemented."
  end

end
