defmodule Tresmid.Config do
  require Logger
  use GenServer
  @moduledoc """

  Stores and provides configuration data to other processes.


  """
  @moduledoc since: "0.1.0"

  ############################# SERVER IMPLEMENTATION ##########################
  @impl true
  def init(config) do
    {:ok, config}
  end

  @impl true
  def handle_cast({:set, key, val}, state) do
    {:noreply, Map.put(state, key, val)}
  end

  @impl true
  def handle_call({:get, key}, _from, state) do
    {:reply, Map.get(state, key), state}
  end

  @impl true
  def handle_call(:dump, _from, state) do
    {:reply, state, state}
  end

  ############################# CLIENT IMPLEMENTATION #########################
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
  def get(key) do
    GenServer.call(:tresmid, {:get, key})
  end

  # Setter
  def set(key, val) do
    GenServer.cast(:tresmid, {:set, key, val})
  end

  def dump do
    GenServer.call(:tresmid, :dump)
  end

  ########################### HELPER FUNCTIONS ################################
  def read_config(path) do
    case YamlElixir.read_from_file(path) do
      {:ok, data} -> GenServer.start_link(
        Tresmid.Config, default(data), name: :tresmid)
      _ -> start_link()
    end
  end

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
