defmodule Tresmid.Database do
  use GenServer

  ################## SERVER IMPLEMENTATION ########################
  @impl true
  def init(conn) do
    {:ok, conn}
  end

  @impl true
  def handle_call(:conn, _from, data) do
    {:reply, data[:conn], data}
  end

  ################## CLIENT IMPLEMENTATION ########################
  def start_link(verbose) do
    {:ok, conn} = Mongo.start_link(
      database: Application.fetch_env!(:tresmid, :mongo_db),
      user: Application.fetch_env!(:tresmid, :mongo_user),
      password: Application.fetch_env!(:tresmid, :mongo_pwd),
      hostname: Application.fetch_env!(:tresmid, :mongo_host),
      port: Application.fetch_env!(:tresmid, :mongo_port),
    )

    GenServer.start_link(Tresmid.Database, %{conn: conn, verbose: verbose}, name: DB)
  end

  def conn() do
    GenServer.call(DB, :conn)
  end




end
