json.array!(@products) do |product|
  json.extract! product, :id, :name, :description, :imageurl, :url, :price
  json.url product_url(product, format: :json)
end
