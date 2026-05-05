class TenantLoginAccount < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  # devise :database_authenticatable, :registerable,
  #        :recoverable, :rememberable, :validatable, :lockable, :timeoutable, :trackable # :confirmable,  ## for disable automatic confirm email.

  devise :database_authenticatable, :lockable, :timeoutable, :trackable

  belongs_to :tenant
  validates :tenant, presence: true, uniqueness: true
  validates :email, presence: true, format: { with: Devise.email_regexp }
end
