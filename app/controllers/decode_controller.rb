require "urm/machine"
require "urm/coder"
class DecodeController < ApplicationController
  def execute
    encoded_machine = params[:encoded_machine]

    if encoded_machine.blank?
      render json: { error: 'Закодированные данные не предоставлены.' }, status: :unprocessable_entity
      return
    end

    begin
      decoded_machine = Urm::Coder.decode_machine(encoded_machine.map(&:to_i))
      instructions = decoded_machine.instructions.map(&:to_s)
      render json: { instructions: instructions }, status: :ok
    rescue => e
      render json: { error: "Ошибка декодирования: #{e.message}" }, status: :unprocessable_entity
    end
  end

end
