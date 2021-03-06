defmodule Conekta.Orders do
  alias Conekta.OrdersResponse
  alias Conekta.Handler
  alias Conekta.OrdersCreateResponse

  def orders do
    Conekta.Client.get_request("orders")
    |> case do
        {:ok, content} ->
          body = Handler.handle_status_code(content)
          {:ok, Poison.decode!(body, as: %OrdersResponse{})}
    end
  end

  def create(order) when is_map(order) do
    Conekta.Client.post_request("orders", order)
    |> case do
        {:ok, content} ->
          body = Handler.handle_status_code(content)
          {:ok, Poison.decode!(body, as: %OrdersCreateResponse{})}
    end
  end

  def update(id, order) do
    Conekta.Client.put_request("orders/"<>id, order)
    |> case do
      {:ok, content} ->
        body = Handler.handle_status_code(content)
        {:ok, Poison.decode!(body)}
    end
  end

end
