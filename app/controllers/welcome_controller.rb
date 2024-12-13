require 'urm/version'

class WelcomeController < ApplicationController
  def index
    @gem_version = Urm::VERSION # Получение версии гема
  end
end
