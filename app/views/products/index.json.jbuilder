json.array!(@products) do |product|
  json.extract! product, :id, :ProdId, :ProdTitle, :ProdDesc, :ProdImageUrl, :ProdUrl, :ProdPrice, :CurrProdPrice
  json.url product_url(product, format: :json)
end
