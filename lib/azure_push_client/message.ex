defmodule AzurePushClient.Message do
  alias AzurePushClient.Authorization, as: Auth
  require Logger

  @moduledoc """
  Simple client for azure notification hubs.
  """

  @doc """
  AzurePushClient.Message.send({namespace, hub, access_key}, %{aps: %{alert: "Testing"}}, ["optional", "tags"], "apple")
  """
  @type namespace :: String.t
  @type hub :: String.t
  @type access_key :: String.t
  @type reason :: atom
  @type format :: String.t
  @type tags :: [String.t]
  @type format_key :: :apns | atom

  @type payload :: %{required(format_key) => %{alert: String.t}}

  @spec send({namespace, hub, access_key}, payload, tags, format) :: {:ok, :sent} | {:error, :unauthenticated} | {:error, reason}
  def send({namespace, hub, access_key}, payload, tags \\ [], format \\ "apple") do
    with {:ok, json_payload} <- Poison.encode(payload),
         {:ok, url} <- url(namespace, hub),
         {:ok, headers} <- setup_headers(url, access_key, format)
      do

      headers
      |> update_headers(tags)
      |> request(url, json_payload)
    end
  end

  @spec update_headers(list, list) :: list
  defp update_headers(headers, tags) do
    case Enum.join(tags, " || ") do
      "" -> headers
      tag_string -> [{"ServiceBusNotification-Tags", tag_string} | headers]
    end
  end

  @spec setup_headers(String.t, String.t, String.t) :: {:ok, list}
  defp setup_headers(url, access_key, format) do
    {:ok, [{"Content-Type", "application/json"},
           {"Authorization", Auth.token(url, access_key)},
           {"ServiceBusNotification-Format", format}]}
  end

  @spec url(String.t, String.t) :: {:ok, String.t}
  defp url(namespace, hub) do
    {:ok, "https://#{namespace}.servicebus.windows.net/#{hub}/messages"}
  end

  @spec request(list, String.t, String.t) :: {:ok, :sent} | {:error, :unauthenticated} | {:error, atom}
  defp request(headers, url, payload) do
    case HTTPoison.post(url, payload, headers, [ssl: [{:versions, [:'tlsv1.2']}]]) do
      {:ok, %HTTPoison.Response{status_code: 201}} ->
        Logger.info "{:azure_push_client, :sent}"
        {:ok, :sent}
      {:ok, %HTTPoison.Response{status_code: 401}} ->
        Logger.error "{:azure_push_client, :unauthenticated}"
        {:error, :unauthenticated}
      {:ok, %HTTPoison.Response{body: body}} ->
        {:error, body}
      {:error, %HTTPoison.Error{reason: reason}} ->
        Logger.error "{:azure_push_client, #{reason}}"
        {:error, reason}
    end
  end
end
