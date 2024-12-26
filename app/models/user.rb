# frozen_string_literal: true

class User < ApplicationRecord
  #attr_accessor :name

  # Другие настройки Devise
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :name, presence: { message: "Имя не может быть пустым" }
  validates :email, presence: { message: "E-mail не может быть пустым" },
                    uniqueness: { message: "Этот e-mail уже используется" },
                    format: { with: URI::MailTo::EMAIL_REGEXP, message: "Неверный формат e-mail" }
  validates :password, presence: { message: "Пароль не может быть пустым" },
                    length: { minimum: 6, message: "Пароль должен содержать минимум 6 символов" },
                    confirmation: { message: "Пароли не совпадают" }
  validates :password_confirmation, presence: { message: "Подтверждение пароля не может быть пустым" }
end
