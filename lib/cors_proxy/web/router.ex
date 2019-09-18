defmodule CorsProxy.Web.Router do
  use CorsProxy.Web, :router

  scope "/", CorsProxy.Web do
    options("/*url", CorsController, :options)
    put("/*url", CorsController, :put)
    post("/*url", CorsController, :post)
    patch("/*url", CorsController, :patch)
    get("/*url", CorsController, :get)
  end
end
