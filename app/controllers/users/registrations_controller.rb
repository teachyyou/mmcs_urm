class Users::RegistrationsController < Devise::RegistrationsController
  def new
    build_resource  # Это создаст новый экземпляр User и присвоит его resource
    respond_with resource  # Это отправит ответ с resource
  end

  def create
    super do |resource|
      if resource.errors.any?
        Rails.logger.error(resource.errors.full_messages)
      end
    end
  end
  private
  def sign_up_params
    params.require(:user).permit(:email, :name, :password, :password_confirmation)
  end

  def account_update_params
    params.require(:user).permit(:email, :name, :password, :password_confirmation, :current_password)
  end

  def after_sign_in_path_for(resource)
    root_path
  end

  def after_sign_out_path_for(resource_or_scope)
    root_path
  end

end
