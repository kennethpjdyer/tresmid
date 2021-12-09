defmodule Tresmid.Edit do
  require Logger
  @moduledoc """
  Provides functions used in opening the given work tree
  in the configured text editor.
  """
  @moduledoc since: "0.1.0"

  @doc """
  Opens the work tree for the specified repository in the configured
  text editor.
  """
  @doc since: "0.1.0"
  def run(repo, ticket) do
    Logger.info("Called edit operation.")
    IO.inspect ticket
  end


  ######################### DOCUMENTATION ############################
  @doc false
  def docs do
    """
    ## ed Command

    Tresmid uses the `ed` command to open a work tree for the specified repository
    using the configured text editor.
    """
  end

  @doc false
  def usage do
    """
    Usage information for ed
    """
  end
end
