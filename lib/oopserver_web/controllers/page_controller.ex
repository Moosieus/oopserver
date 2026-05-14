defmodule OopserverWeb.PageController do
  use OopserverWeb, :controller

  def home(conn, _params) do
    render(conn, :home)
  end
end
