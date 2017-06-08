defmodule AzurePushClient.Authorization do
  @key_name "DefaultFullSharedAccessSignature"
  @sig_lifetime 10

  @moduledoc false

  def token(url, access_key) do
    with {:ok, target_uri} <- target_uri(url),
         {:ok, expires} <- expires(@sig_lifetime),
         {:ok, to_sign} <- to_sign(target_uri, expires),
         {:ok ,signature} <- signature(access_key, to_sign),
    do: "SharedAccessSignature sr=#{target_uri}&sig=#{signature}&se=#{expires}&skn=#{@key_name}"
  end

  defp target_uri(url) do
    uri = url
    |> String.downcase
    |> URI.encode_www_form
    |> escape_plus
    {:ok, uri}
  end

  defp expires(lifetime) do
    {:ok, :os.system_time(:seconds) + lifetime}
  end

  defp to_sign(target_uri, expires) do
    {:ok, "#{target_uri}\n#{expires}"}
  end

  defp signature(access_key, to_sign) do
    sig = :sha256
    |> :crypto.hmac(access_key, to_sign)
    |> Base.encode64
    |> URI.encode_www_form
    |> escape_plus

    {:ok, sig}
  end

  defp escape_plus(string) do
    Regex.replace(~r/\+/, string, "%20", global: true)
  end
end
