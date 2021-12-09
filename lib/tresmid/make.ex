defmodule Tresmid.Make do
  require Logger

  @moduledoc """
  Provides functions used in creating work trees from the given repository.
  """
  @moduledoc since: "0.1.0"

  @doc """
  Creates a new work tree branch for the given repository.
  """
  @doc since: "0.1.0"
  def run(repo, ticket, text, upstream) do
    Logger.info("Called make operation.")
    IO.inspect {repo, ticket, text, upstream}
  end

  ######################## DOCUMENTATION ############################
  @doc false
  def docs do
    """
    ## mk Command

    Tresmid uses the `mk` command to create a work tree from the given repository.
    """
  end

  @doc false
  def usage do
    """
    Usage function for mk
    """
  end
end
