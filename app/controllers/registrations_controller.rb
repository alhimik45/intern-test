class RegistrationsController < Devise::RegistrationsController
  protected

  def sign_up(resource_name, resource)
    #sign_in(resource_name, resource)
    sign_in(:user, resource)
  end
end