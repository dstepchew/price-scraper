class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :pins

  validates :name, uniqueness: { case_sensitive: false, message: "this username has been taken" }
  validates_presence_of :name
 

  def admin?
    role == 'ADMIN'
  end

  def tagged_products
    pins.collect(&:product).uniq
  end
end
