# frozen_string_literal: true

# Configure your routes here
# See: https://guides.hanamirb.org/routing/overview
#

json_endpoint = ->(env) { Api::Controllers::V1::Whois.new.call(query: env["router.params"][:request]) }

get "/", to: "home#index"
get "/:request", to: "home#show"
get "/:request/json", to: json_endpoint
get "/*", to: "home#show"
