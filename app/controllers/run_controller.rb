class RunController < ApplicationController
  def execute
    machine = Machine.find_by(id: params[:id])

    unless machine
      render json: { error: 'Машина не найдена.' }, status: :not_found
      return
    end

    inputs = params[:inputs]

    if inputs.blank? || !inputs.is_a?(ActionController::Parameters)
      render json: { error: 'Входные данные недействительны или отсутствуют.' }, status: :unprocessable_entity
      return
    end

    # Объявляем input_array вне блока begin...rescue
    input_array = inputs.values.map do |val|
      Integer(val) rescue nil
    end

    if input_array.any?(&:nil?) || input_array.any? { |val| val.negative? }
      render json: { error: 'Входные данные должны быть целыми числами >= 0.' }, status: :unprocessable_entity
      return
    end

    Rails.logger.info "Запущена машина #{machine.id} с входными данными: #{inputs}"

    result = nil
    error = nil

    machine_worker = Urm::Machine.new(machine.input_counts)
    machine_worker.add_all(machine.instructions)

    worker_thread = Thread.new do
      begin
        result = machine_worker.run(*input_array)
      rescue => e
        error = e.message
      end
    end

    if worker_thread.join(5).nil?
      Thread.kill(worker_thread)
      render json: { error: 'Время выполнения превысило лимит.' }, status: :request_timeout
      return
    end

    if error
      render json: { error: "Ошибка выполнения: #{error}" }, status: :unprocessable_entity
    else
      render json: { output: result }
    end
  end
end
