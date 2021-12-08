defmodule Tresmid.Remote do
  @moduledoc """
  Provides functions for configuring and interacting with remote repositories.
  """

  ##################### COMMAND-LINE FUNCTIONS #################################

  @doc """
  Adds a remote to the speicified repository configuration.

  This function is called from the command-line using a `remote` sub-command.

  ```console
  $ tresmid remote add example-repo origin git@github.com:user/example-repo
  ```
  """
  @doc since: "0.1.0"
  def add(repo, remote, url) do
    case Mongo.update_one(
      Tresmid.Database.conn(),
      :repos,
      %{repo: repo},
      %{"$set": %{
        "remotes.#{remote}": url
      }}
    ) do
      {:ok, _} -> IO.puts("Remote #{remote} added to #{repo} configuration.")
      {:error, reason} -> IO.puts("Error adding remote to #{repo}: #{reason}")
    end
  end

  @doc """
  Removes the given remote from a repository configuration.

  This function is called from the command-line using a `remote` sub-command.

  ```console
  $ tresmid remote drop example-repo origin
  ```
  """
  @doc since: "0.1.0"
  def drop(repo, remote) do
    case Mongo.update_one(
      Tresmid.Database.conn(),
      :repos,
      %{repo: repo},
      %{"$set": %{
        remote: remote
      }}
    ) do
      {:ok, _} -> IO.puts("Remote #{remote} added to #{repo} configuration.")
      {:error, reason} -> IO.puts("Error adding remote to #{repo}: #{reason}")
    end
  end

  @doc """
  Lists the configured remotes for the specified repository.  If no repository
  is provided, lists all repositories.
  """
  @doc since: "0.1.0"
  def list(repo) do
  end

  def list do
  end

  ############################# DOCUMENTATION ##################################
  @doc false
  def docs do
    """
    ## remote

    Tresmid uses the `remote` command to set up remote repositories for the
    given repository configuration.  If you plan to use a remote repository,
    you should at least configure one, such as `origin` for Tresmid to utilize.

    | Sub-Command | Description |
    |---|---|
    | `add` | Adds a remote to the specified repository configuration. |
    | `drop` | Removes a remote from the specified repository configuration. |

    ### remote add

    Adds a remote to the specified repository configuration.

    ```console
    $ tresmid remote add example-repo origin git@github.com:user/example-repo
    ```

    ### remote drop

    Removes a remote from the speciifed repository configuration.

    ```console
    $ tresmid remote drop example-repo origin
    ```

    """
  end

  def usage do
    "Usage for remote not yet implemented."
  end


end
