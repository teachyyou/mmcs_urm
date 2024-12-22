class Users::RegistrationsController < Devise::RegistrationsController
  def new
    build_resource  # Это создаст новый экземпляр User и присвоит его resource
    respond_with resource  # Это отправит ответ с resource
  end
end
