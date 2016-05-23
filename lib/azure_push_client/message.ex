defmodule AzurePushClient.Message do
  @namespace Application.get_env(:azure_push_client, :azure_namespace)
  @hub Application.get_env(:azure_push_client, :azure_hub)

  use GenServer
  alias AzurePushClient.Authorization, as: Auth

  def start_link do
    GenServer.start_link(__MODULE__, [], name: AzurePushClient)
  end

  def send(payload) do
    GenServer.cast(AzurePushClient, {:send, payload})
  end

  def handle_cast({:send, payload}, state) do
    _send(payload)
    {:noreply, state}
  end

  defp _send( payload, tags \\ [], format \\ "apple") do
    json_payload = Poison.encode!(payload)
    url = url(@namespace, @hub)
    content_type = "application/json"
    headers = [
      {"Content-Type", content_type},
      {"Authorization", Auth.token(url)},
      {"ServiceBusNotification-Format", format}
    ]
    request(url, json_payload, headers)
  end

  defp url(namespace, hub) do
    "https://#{namespace}.servicebus.windows.net/#{hub}/messages"
  end

  defp request(url, payload, headers) do
    case HTTPoison.post(url, payload, headers) do
      {:ok, %HTTPoison.Response{status_code: 201}} ->
        {:ok, :sent}
      {:ok, %HTTPoison.Response{status_code: 401}} ->
        {:error, :unauthenticated}
      {:error, %HTTPoison.Error{reason: reason}} ->
        {:error, reason}
    end
  end
end
