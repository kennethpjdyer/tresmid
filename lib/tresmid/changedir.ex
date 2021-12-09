defmodule Tresmid.ChangeDir do
  require Logger
  @moduledoc """
  Provides functions used in changing from the current directory into the
  directory of the given repository and work tree.
  """
  @moduledoc since: "0.1.0"


  @doc """
  Changes from the current directory into the directory of the specified
  repository and work tree.
  """
  @doc since: "0.1.0"
  def run(repo, ticket) do
    Logger.info("Called change directory operation.")

    IO.inspect ticket
  end

  ########################## DOCUMENTATION ################################
  @doc false
  def docs do
    """
    ## cd Command

    Tresmid uses the `cd` command to change into the directory of the specified
    repository and work tree.
    """
  end

  @doc false
  def usage do
    """
    usage docs for cd command.
    """
  end

end
