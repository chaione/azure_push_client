# AzurePushClient

Send push notifications through Azure

Base on: https://github.com/christian-s/azure-push

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed as:

  1. Add azure_push_client to your list of dependencies in `mix.exs`:

        def deps do
          [{:azure_push_client, "~> 0.0.1"}]
        end

  2. Ensure azure_push_client is started before your application:

        def application do
          [applications: [:azure_push_client]]
        end

## Config

``` elixir
config :azure_push_client,
  azure_namespace: "...",
  azure_hub: "...",
  azure_access_key: "..."
```
