json.array!(@stores) do |store|
  json.extract! store, :id, :name, :url, :description
  json.url store_url(store, format: :json)
end
