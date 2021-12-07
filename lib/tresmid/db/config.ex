defmodule Tresmid.Database.Config do

  @moduledoc """
  Provides functions for the `config` command.
  """
  @moduledoc since: "0.1.0"

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


  ########################### CLI CONFIG SUB-COMMANDS ##########################
  @doc """
  Dump configuration data to stdout for reference.

  This function is called from the command-line using a `config` sub-command.

  ```console
  $ tresmid config dump
  ```
  """
  @doc since: "0.1.0"
  def dump do
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
  end

  @doc """
  Initialize configuration document in MongoDB.

  This function is called from the command-line using a `config` sub-command.

  ```console
  $ tresmid config init
  ```
  """
  @doc since: "0.1.0"
  def init do
  end




end
