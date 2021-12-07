defmodule Tresmid.Config do

  @moduledoc """
  Provides functions for the `config` command.
  """
  @moduledoc since: "0.1.0"

  @doc """
  Helper function that provides a UTC timestamp, formatted for MongoDB.
  """
  @doc since: "0.1.0"
  def now do
    Mongo.timestamp(DateTime.utc_now())
  end

  @doc """
  Provides a map that contains the default configuration of Tresmid.

  This function is used by `Tresmid.Config.init to set the default
  configuration document in MongoDB.
  """
  @doc since: "0.1.0"
  def default_config do
    %{
      root_dir: Path.expand("~/.tresmid"),
      github_user: nil,
      github_email: nil,
      mtime: now()
    }
  end

  ########################### CLI CONFIG SUB-COMMANDS ##########################
  @doc """
  Dump configuration data to stdout for reference.

  This function is called from the command-line using a `config` sub-command.

  ```console
  $ tresmid config dump
  Tresmid Configuration:",
  - Tresmid Root: /home/user/.tresmid
  - GitHub Configuration:",
    - GitHub User: username
    - GitHub Email: user@example.com
  ```
  """
  @doc since: "0.1.0"
  def dump do
    data = Mongo.find_one(
      Tresmid.Database.conn(),
      :config,
      %{},
      [projection: %{ _id: 0}]
    )

    [
      "Tresmid Configuration:",
      "- root_dir: #{data["root_dir"]}",
      "- GitHub Configuration:",
      "  - github_user: #{data["github_user"]}",
      "  - github_email: #{data["github_email"]}",
    ]
    |> Enum.join("\n")
    |> IO.puts
  end

  @doc """
  Retrieve the value specified for the given variable from the configuraiton
  document.

  This function is called from the command-line using a `config` sub-command.

  ```console
  $ tresmid config get repos_home
  ```
  """
  @doc since: "0.1.0"
  def get(var) do
    data = Mongo.find_one(
      Tresmid.Database.conn(),
      :config,
      %{},
      [projection: %{ _id: 0}]
    )

    IO.puts("#{var}: #{Map.get(data, var)}")
  end

  @doc """
  Initialize configuration document in MongoDB.

  This function is called from the command-line using a `config` sub-command.

  ```console
  $ tresmid config init
  Configuration updated
  ```
  """
  @doc since: "0.1.0"
  def init do
    case Mongo.update_one(
      Tresmid.Database.conn(),
      :config,
      %{name: "config"},
      %{"$set": default_config()},
      [upsert: true]
    ) do
      {:ok, _} -> IO.puts("Configuration updated")
      {:error, reason} -> IO.puts("Error updating config: #{reason}")
    end
  end

  @doc """
  Specifies a new value for the given configuration option.

  This function is called from teh command-line using a `config` sub-command.

  ```console
  $ tresmid config set repos_home ~/.work-repos
  ```
  """
  @doc since: "0.1.0"
  def set(var, value) do
    case Mongo.update_one(
      Tresmid.Database.conn(),
      :config,
      %{name: "config"},
      %{"$set": %{var => value}},
      [upsert: true]
    ) do
      {:ok, _} -> IO.puts("#{var} configuration option updated")
      {:error, reason} -> IO.puts("Error updating config: #{reason}")
    end
  end

  ########################### DOCUMENTATION FUNCTIONS ########################
  @doc false
  def docs do
    """
    #### config

    Tresmid stores its configuration in a MongoDB document located in the
    `tresmid.config` collection.   Sub-commands under `config` allow for
    interaction with this document, including initializing it with or reverting
    it to its default settings, updating specific configuration options, and
    dumping the configuration to stdout for reference.

    Supported sub-commands include:any()

    | Sub-Command | Description |
    |---|---|
    | `dump` | Prints the global configuration to stdout. |
    | `get` | Retrieves the value set for the given configuration option. |
    | `init` | Initalizes the configuration document in the database. |
    | `set` | Sets the given configuration option to the specified value. |

    ##### config dump

    Prints the global configuration to stdout.

    The global configuration values can also be accessed directly through MongoDB
    by querying the `tresmid.config` collection for its sole document.

    ```javascript
    use tresmid
    db.config.find()
    ```


    ##### config get

    Retrieves the value set for the given configuration option.

    ```console
    $ tresmid config get repos_home
    /home/user/.work-repos
    ```

    ##### config init

    Initializes the configuration document, resetting all values to their defaults.
    The sub-command takes no arguments

    ```console
    $ tresmid config init
    ```

    ##### config set

    Sets the given configuration option to the specified value.

    ```console
    $ tresmid config set repos_home ~/.work-repos
    ```
    """
  end


  @doc false
  def usage do
    "Usage text for the config command and sub-commands has not yet been written."
  end
end
