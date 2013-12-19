json.array!(@stores) do |store|
  json.extract! store, :id, :StoreId, :StoreTitle, :StoreUrl, :StoreDesc
  json.url store_url(store, format: :json)
end
