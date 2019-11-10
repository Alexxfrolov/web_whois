# frozen_string_literal: true

# Configure your routes here
# See: https://guides.hanamirb.org/routing/overview
#

json_endpoint = ->(env) do
  if env["REQUEST_PATH"].match?(/(^\/(http:\/\/|www))|\/json\/?(.+)/)
    cleaned_request = env["router.params"][:request].gsub(/^www\./, "")

    [301, {"Location" => "/#{cleaned_request}/json"}, []]
  else
    Api::Controllers::V1::Whois.new.call(
      query: env["router.params"][:request].gsub(/^www\./, ""))
  end
end


get "/", to: "home#index"
get "/http:/:/:request/json/*", to: json_endpoint
get "/https:/:/:request/json/*", to: json_endpoint
get "/:request/json/*", to: json_endpoint
get "/http:/:/:request/*", to: "home#show"
get "/https:/:/:request/*", to: "home#show"
get "/:request/*", to: "home#show"
