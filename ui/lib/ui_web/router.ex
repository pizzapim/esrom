defmodule UiWeb.Router do
  use UiWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", UiWeb do
    pipe_through :browser

    get "/", PageController, :index

    get "/ZZZZ", PageController, :instructions
    get "/morse", PageController, :instructions
    get "/esrom", PageController, :instructions

    get "/0B13", PageController, :morse
    get "/OB13", PageController, :morse
    get "/seinlamp", PageController, :morse

    get "/start", PageController, :start
  end
end
