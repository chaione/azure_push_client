defmodule AzurePushClient.Authorization do
  @key_name "DefaultFullSharedAccessSignature"
  @sig_lifetime 10

  def token(url, access_key) do
    target_uri = target_uri(url)
    expires = expires(@sig_lifetime)
    to_sign = to_sign(target_uri, expires)
    signature = signature(access_key, to_sign)
    "SharedAccessSignature sr=#{target_uri}&sig=#{signature}&se=#{expires}&skn=#{@key_name}"
  end

  defp target_uri(url) do
    url
    |> String.downcase
    |> URI.encode_www_form
    |> escape_plus
  end

  defp expires(lifetime) do
    :os.system_time(:seconds) + lifetime
  end

  defp to_sign(target_uri, expires) do
    "#{target_uri}\n#{expires}"
  end

  defp signature(access_key, to_sign) do
    :crypto.hmac(:sha256, access_key, to_sign)
    |> Base.encode64
    |> URI.encode_www_form
    |> escape_plus
  end

  defp escape_plus(string) do
    Regex.replace(~r/\+/, string, "%20", global: true)
  end
end
