defmodule AzurePushClient.Message do
  use GenServer
  alias AzurePushClient.Authorization, as: Auth

  def start_link do
    GenServer.start_link(__MODULE__, [], name: AzurePushClient)
  end

  def send({namespace, hub, access_key}, payload) do
    GenServer.cast(AzurePushClient, {:send, payload, namespace, hub, access_key})
  end

  def handle_cast({:send, payload, namespace, hub, access_key}, state) do
    _send(payload, {namespace, hub, access_key})
    {:noreply, state}
  end

  defp _send( payload, {namespace, hub, access_key}, tags \\ [], format \\ "apple") do
    json_payload = Poison.encode!(payload)
    url = url(namespace, hub)
    content_type = "application/json"
    headers = [
      {"Content-Type", content_type},
      {"Authorization", Auth.token(url, access_key)},
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
