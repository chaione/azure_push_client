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
Function signature: send({namespace, hub, access_key}, payload, tags \\ [], format \\ "apple")

AzurePushClient.Message.send({namespace, hub, access_key}, %{aps: %{alert: "Testing"}})
AzurePushClient.Message.send({namespace, hub, access_key}, %{aps: %{alert: "Testing"}}, ["tags"], "apple")
```
## TODO

- Google cloud messaging

## Notes
   Version 1.0.0 removes OTP.
