class Product < ActiveRecord::Base
    
  # I can't figure out how to test ElasticSearch in development without getting connection refused errors...
  # include Tire::Model::Search
  # include Tire::Model::Callbacks
  belongs_to :store
  validates_presence_of :url, :price, :name
  validates_uniqueness_of :url
  has_many :pins, :dependent => :destroy
  has_many :product_price_updates, through: :pins
  accepts_nested_attributes_for :pins, :allow_destroy => true
  self.per_page = 6
  before_save :update_url
  #after_update :update_store

  def update_url
    self.url = self.url.strip if self.url
  end

  def update_store
    self.store.update_attribute(:status, self.status)
  end
  
  def exact_url
    URI.extract(self.url).first
  end

  #private
  #url = "http://www.medelita.com/lab-coat-callia.html"
  #doc = Nokogiri::HTML(open(url))
  #doc.css("store.product_selector").each do |item|
    #ptitle = item.at_css("store.name_selector").text
    #pprice = item.at_css("store.price_selector").text[/\$[0-9\.]+/]        		
  #end
end
