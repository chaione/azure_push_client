# AzurePushClient

Send push notifications through Azure

Base on: https://github.com/christian-s/azure-push

## Installation

  1. Add azure_push_client to your list of dependencies in `mix.exs`:

        def deps do
          [{:azure_push_client, github: "chaione/azure_push_client"}]
        end

  2. Ensure azure_push_client is started before your application:

        def application do
          [applications: [:azure_push_client]]
        end

## Usage

``` elixir
AzurePushClient.Message.send %{aps: %{alert: "Testing"}}
```

## Config

``` elixir
config :azure_push_client,
  azure_namespace: "...",
  azure_hub: "...",
  azure_access_key: "..."
```

## TODO

- Google cloud messaging
- Tags
