defmodule Tresmid.Remove do
  require Logger

  def run(repo, ticket) do
    Logger.info("Called remove operation.")
    IO.inspect ticket
  end

  ########################## DOCUMENTATION ##############################
  def docs do
    """
    ## rm Command

    TODO: Document remove Command
    """
  end

  def usage do
    """
    Usage text for rm command.
    """
  end
end
