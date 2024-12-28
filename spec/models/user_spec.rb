require "rails_helper"

RSpec.describe User, type: :model do
  describe "validations" do
    let(:valid_attributes) do
      {
        name: "Test User",
        email: "test@example.com",
        password: "password",
        password_confirmation: "password"
      }
    end

    it "is valid with valid attributes" do
      user = User.new(valid_attributes)
      expect(user).to be_valid
    end

    it "is invalid without a name" do
      user = User.new(valid_attributes.merge(name: nil))
      expect(user).not_to be_valid
      expect(user.errors[:name]).to include("Имя не может быть пустым")
    end

    it "is invalid without an email" do
      user = User.new(valid_attributes.merge(email: nil))
      expect(user).not_to be_valid
      expect(user.errors[:email]).to include("E-mail не может быть пустым")
    end

    it "is invalid with a duplicate email" do
      User.create!(valid_attributes)
      duplicate_user = User.new(valid_attributes)
      expect(duplicate_user).not_to be_valid
      expect(duplicate_user.errors[:email]).to include("Этот e-mail уже используется")
    end

    it "is invalid with an improperly formatted email" do
      user = User.new(valid_attributes.merge(email: "invalid-email"))
      expect(user).not_to be_valid
      expect(user.errors[:email]).to include("Неверный формат e-mail")
    end

    it "is invalid without a password" do
      user = User.new(valid_attributes.merge(password: nil))
      expect(user).not_to be_valid
      expect(user.errors[:password]).to include("Пароль не может быть пустым")
    end

    it "is invalid with a password shorter than 6 characters" do
      user = User.new(valid_attributes.merge(password: "123", password_confirmation: "123"))
      expect(user).not_to be_valid
      expect(user.errors[:password]).to include("Пароль должен содержать минимум 6 символов")
    end

    it "is invalid without a password confirmation" do
      user = User.new(valid_attributes.merge(password_confirmation: nil))
      expect(user).not_to be_valid
      expect(user.errors[:password_confirmation]).to include("Подтверждение пароля не может быть пустым")
    end

    it "is invalid when password and password confirmation do not match" do
      user = User.new(valid_attributes.merge(password_confirmation: "different_password"))
      expect(user).not_to be_valid
      expect(user.errors[:password_confirmation]).to include("Пароли не совпадают")
    end
  end

end
