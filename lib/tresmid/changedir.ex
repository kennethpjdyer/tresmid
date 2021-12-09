defmodule Tresmid.ChangeDir do
  require Logger


  def run(repo, ticket) do
    Logger.info("Called change directory operation.")

    IO.inspect ticket
  end

  ########################## DOCUMENTATION ################################
  def docs do
    """
    ## cd Command

    TODO Document cd command.
    """
  end

  def usage do
    """
    usage docs for cd command.
    """
  end

end
