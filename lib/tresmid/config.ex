defmodule Tresmid.Config do
  require Logger
  use GenServer
  @moduledoc """

  Stores and provides configuration data to other processes.


  """
  @moduledoc since: "0.1.0"

  ############################# SERVER IMPLEMENTATION ##########################
  @doc false
  @impl true
  def init(config) do
    {:ok, config}
  end

  @doc false
  @impl true
  def handle_cast({:set, key, val}, state) do
    {:noreply, Map.put(state, key, val)}
  end

  @doc false
  @impl true
  def handle_call({:get, key}, _from, state) do
    {:reply, Map.get(state, key), state}
  end

  @doc false
  @impl true
  def handle_call(:dump, _from, state) do
    {:reply, state, state}
  end

  ############################# CLIENT IMPLEMENTATION #########################
  @doc """
  Initialize configuration server
  """
  @doc since: "0.1.0"
  def start_link do
    GenServer.start_link(Tresmid.Config, default(), name: :tresmid)
  end

  def start_link(nil) do
    start_link(Path.expand("~/.config/tresmid/config.yml"))
  end

  def start_link(cpath) do
    confpath = Path.expand(cpath)
    cond do
      # Confpath Exists
      File.regular?(confpath) -> read_config(confpath)

      # Default Confpath
      true -> start_link()
    end
  end

  # Getter
  @doc """
  Retrieve a configuration value from the server.
  """
  @doc since: "0.1.0"
  def get(key) do
    GenServer.call(:tresmid, {:get, key})
  end

  # Setter
  @doc """
  Sets a configuration value on the server.
  """
  @doc since: "0.1.0"
  def set(key, val) do
    GenServer.cast(:tresmid, {:set, key, val})
  end

  @doc """
  Returns the current configuration.
  """
  @doc since: "0.1.0"
  def dump do
    GenServer.call(:tresmid, :dump)
  end

  ########################### HELPER FUNCTIONS ################################
  @doc """
  Reads the configuration YaML and merges its data with the default configuration.
  """
  @doc since: "0.1.0"
  def read_config(path) do
    case YamlElixir.read_from_file(path) do
      {:ok, data} -> GenServer.start_link(
        Tresmid.Config, default(data), name: :tresmid)
      _ -> start_link()
    end
  end

  @doc """
  Retrieves the cache data from the cache YaML, creates the cache if it does
  not exist.
  """
  @doc since: "0.1.0"
  def read_cache do
    case YamlElixir.read_from_file(get("cache_path")) do
      {:ok, data} ->
        data
      {:error, reason} ->
        Logger.warn("Error reading cache, #{reason}")
        Tresmid.Update.run
        read_cache()
    end
  end

  @doc """
  Retrieves the main branch from the given repository, returns `nil` if the
  main branch is not set.
  """
  def get_main(repo, conf) do
    mains = Enum.filter(repo, fn x ->
      x["branch"] == conf["main"]

    end)
    if length(mains) > 0 do
      Enum.at(mains, 0)
    else
      nil
    end
  end

  @doc false
  def default do
    %{
      "repo_home" => Path.expand("~/.tresmid"),
      "cache_path" => Path.expand("~/.config/tresmid/cache"),
      "verbose" => false,
      "repos" => %{},
      "editor" => "code"
    }
  end
  def default(config) do
    Map.merge(default(), config)
  end

end
