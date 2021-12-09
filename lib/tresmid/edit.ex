defmodule Tresmid.Edit do
  require Logger

  def run(repo, ticket) do
    Logger.info("Called edit operation.")
    IO.inspect ticket
  end


  ######################### DOCUMENTATION ############################
  def docs do
    """
    ## ed Command

    TODO: Document ed Command
    """
  end

  def usage do
    """
    Usage information for ed
    """
  end
end
