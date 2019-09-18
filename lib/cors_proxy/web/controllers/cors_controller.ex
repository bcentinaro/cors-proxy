defmodule CorsProxy.Web.CorsController do
  use CorsProxy.Web, :controller
  require Logger
  import CorsProxy, only: [request: 4, write_response: 2, put_access_control_headers: 1]

  def get(conn, params) do
    :get
    |> request(params["url"], conn.req_headers, "")
    |> write_response(conn)
  end

  def post(conn, params) do
    {:ok, _, conn} = Plug.Conn.read_body(conn)

    :post
    |> request(params["url"], conn.req_headers, conn.body_params)
    |> write_response(conn)
  end

  def put(conn, params) do
    {:ok, _, conn} = Plug.Conn.read_body(conn)

    :put
    |> request(params["url"], conn.req_headers, conn.body_params)
    |> write_response(conn)
  end

  def delete(conn, params) do
    :delete
    |> request(params["url"], conn.req_headers, "")
    |> write_response(conn)
  end

  def options(conn, _params) do
    conn
    |> put_access_control_headers
    |> send_resp(:ok, "")
  end
end
