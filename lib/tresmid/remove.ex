defmodule Tresmid.Remove do
  require Logger

  @moduledoc """

  Provides functions used in removing work trees from a local Git repository.
  """
  @moduledoc since: "0.1.0"

  @doc """
  Removes the given ticket branch from the repository.
  """
  @doc since: "0.1.0"
  def run(repo, tickets) do
    Logger.info("Called remove operation.")
    IO.inspect tickets
  end

  ########################## DOCUMENTATION ##############################
  @doc false
  def docs do
    """
    ## rm Command

    Tresmid uses the `rm` command to remove a work tree.
    """
  end

  @doc false
  def usage do
    """
    Usage text for rm command.
    """
  end
end
