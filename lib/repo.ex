defmodule Tresmid.Repo do
  @moduledoc """
  Provides functions for configuration and interaction with Git repositories.
  """

  ################# HELPER FUNCTIONS #####################
  def default_config(repo) do
    data = Mongo.find_one(
      Tresmid.Database.conn(),
      :config,
      %{},
      [projection: %{_id: 0, mtime: 0}]
    )

    %{
      repo: repo,
      path: Path.join(data["root_dir"], repo),
      github_user: data["github_user"],
      github_email: data["github_email"],
      remotes: %{},
      worktrees: %{},
      main: "master"
    }
  end


  ##################### COMMAND-LINE FUNCTIONS ####################
  @doc """
  Add a repository document to MongoDB.

  This function is called from the command-line,
  using a `repo` sub-command.

  ```console
  $ tresmid repo add example-repo
  $ ls ~/.tresmid
  example-repo
  ```
  """
  @doc since: "0.1.0"
  def add(repo) do
    data = default_config(repo)
    if !File.exists?(data[:path]) do
      File.mkdir_p(data[:path])
    end

    case Mongo.update_one(
      Tresmid.Database.conn(),
      :repos,
      %{repo: repo},
      %{"$set": data},
      [upsert: true]
    ) do
      {:ok, _} -> IO.puts("Repository #{repo} created with default configuration.")
      {:error, reason} -> IO.puts("Error creating repo: #{reason}")

    end
  end

  @doc """
  Prints the configuration of the given repository to stdout.

  This function is called from the command-line using a
  `repo` sub-command.

  ```console
  $ tresmid repo dump example-repo
  ```
  """
  @doc since: "0.1.0"
  def dump(repo) do
    data = Mongo.find_one(
      Tresmid.Database.conn(),
      :repos,
      %{repo: repo},
      [projection: %{ _id: 0}]
    )

    [
      "Repository Configuration:",
      "- repo: #{data["repo"]}",
      "- path: #{data["path"]}",
      "- main: #{Enum.join(data["main"], ", ")}",
      "",
      "GitHub Configuration:",
      "- github_user: #{data["github_user"]}",
      "- github_email: #{data["github_email"]}",
      "",
      "Remote Configuration:",
      "",
      "Work Tree Configuration:",
    ]
    |> Enum.join("\n")
    |> IO.puts

    # TODO: Add configuration for Remotes and Work Trees.

  end

  @doc """
  Removes a repository document from MongoDB.

  This function is called from the command-line using
  a `repo` sub-command.

  ```console
  $ tresmid drop example-repo
  ```
  """
  @doc since: "0.1.0"
  def drop(repo) do
    Mongo.delete_one(
      Tresmid.Database.conn(),
      :repos,
      %{repo: repo}
    )
  end

  @doc """
  Retrieves the value of a configuration option
  for the given repository.

  This funciton is called from the command-line
  using a `repo` sub-command.

  ```console
  $ tresmid repo get example-repo github_email
  github_email: user@example.com
  ```
  """
  @doc since: "0.1.0"
  def get(repo, var) do
    data = Mongo.find_one(
      Tresmid.Database.conn(),
      :repos,
      %{repo: repo},
      [projection: %{ _id: 0}]
    )

    IO.puts("#{var}: #{Map.get(data, var)}")
  end

  @doc """
  Initializes the repository, cloning the specified main branches into the
  configured repository home directory.

  This function is called from the command-line using a `repo` sub-command.

  ```console
  $ tresmid repo init example-repo
  ```
  """
  @doc since: "0.1.0"
  def init(repo) do
    document = Mongo.find_one(
      Tresmid.Database.conn(),
      :repos,
      %{
        remotes: %{"$exists": true},
        repo: repo
      }
    )

    path = Path.join(document["path"], document["main"])

    if Enum.count(document["remotes"]) > 1 do
      up = document["remotes"]["upstream"]
      {:ok, git} = Git.clone([up, path])
      {:ok, _} = Git.pull(git)
    else
      up = document["remotes"]["origin"]
      {:ok, git} = Git.clone([up, path])
      {:ok, _} = Git.pull(git)
    end
  end

  @doc """
  Lists available repositories.
  """
  @doc since: "0.1.0"
  def list do
    Mongo.find(
      Tresmid.Database.conn(),
      :repos,
      %{remotes: %{"$exists": true}}
    )
    |> Enum.to_list
    |> Enum.map(
      fn repo ->
        "#{repo["repo"]}: #{Enum.count(repo["remotes"])} remotes / #{Enum.count(repo["worktrees"])} worktrees"
      end
    )
    |> Enum.join("\n")
    |> IO.puts


  end

  @doc """
  Sets the value on the given repository configuration value.

  This function is called from the command-line
  using a `repo` sub-command.

  ```console
  $ tresmid repo set example-repo github_email user@example.com
  ```

  Note that the `repo` interface cannot be used to update remotes or worktrees.
  """
  @doc since: "0.1.0"
  def set(repo, var, val) when var in ["remotes", "worktree"] do
    IO.puts("ERROR: The repo interface cannot be used to update #{var} repository configuration")
  end

  @doc since: "0.1.0"
  def set(repo, var, val) do
    case Mongo.update_one(
      Tresmid.Database.conn(),
      :repos,
      %{repo: repo},
      %{"$set": %{var => val}},
      [upsert: true]
    ) do
      {:ok, _} -> IO.puts("Repository #{repo} created with default configuration.")
      {:error, reason} -> IO.puts("Error creating repo: #{reason}")

    end
  end

  ######################### DOCUMENTATION FUNCTIONS ###########################
  @doc false
  def docs do
    """
    ## repo

    Tresmid uses the `repo` command to configure local repositories.
    Sub-commands allow for listing available repositories,
    adding and removing repository configurations,
    modifying configuration values, and initializing main branches.

    | Sub-Command | Description |
    |---|---|
    | `add` | Adds a repository document with a default configuration to MongoDB. |
    | `drop`| Removes a repository document from MongoDB. |
    | `dump` | Prints the repository configuration to stdout. |
    | `init` | Initialize main branches. |
    | `get` | Retrieves the value of a repository configuration option. |
    | `set` | Sets a value on the given repository configuration variable. |

    ### repo add

    Adds a repository document to MongoDB.

    Repositories start out with a default configuration
    set to the current directory.  The configuration is inserted
    as a document in a MongoDB document in the `tresmid.repos`
    collection.  This document requires further configuration to use.

    To further configure the repository, see `repo set`.

    ```console
    $ tresmid repo add example-repo
    ```

    ### repo drop

    Removes a repository document from MonoDB.

    Repository documents contain the full configuration
    of the repository, as well as all work tree branches added
    to the repository.

    > **Warning**: Dropping a repository configuration is not reversable.

    ```console
    $ tresmid repo drop example-repo
    ```

    ### repo dump

    Prints the repository configuration to stdout.

    ```console
    $ tresmid repo dump example
    ```

    ### repo init

    Clones the main branch of the repository into the configured directory.

    ```console
    $ tresmid repo init example-repo
    ```

    ### repo get

    Retrieves the current value of a repository configuration option.

    ```console
    $ tresmid repo get example-repo repo_home
    /home/user/.work-repos/example-repo
    ```

    ### repo set

    Sets a new value on the specified repository configuration option.

    ```console
    $ tresmid repo set example-repo github_email user@example.com
    ```

    """
  end

  @doc false
  def usage do
    "Usage text for the repo command has not yet been implemented."
  end

end
