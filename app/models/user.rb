# frozen_string_literal: true

class User < ApplicationRecord
  #attr_accessor :name

  # Другие настройки Devise
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # Убедитесь, что поле name доступно для массового присвоения
  validates :name, presence: true

  validates :password, length: { minimum: 6, message: "должен содержать минимум 6 символов" }
end
