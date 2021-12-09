defmodule Tresmid.Update do
  require Logger
  @moduledoc """
  Provides functions used to manage the update process, ensuring that the
  repository cache is up to date with what is available on the file system.
  """
  @moduledoc since: "0.1.0"

  @doc """
  Updates the local cache, matching tickets to work tree branches in the
  configured repositories.
  """
  def run do
    Logger.info("Called update operation.")
  end

  ########################### DOCUMENTATION ############################
  @doc false
  def docs do
    """
    ## up Command

    Tresmid uses the `up` command to update the repository cache.
    """
  end

  @doc false
  def usage do
    """
    usage docs for up
    """
  end
end
