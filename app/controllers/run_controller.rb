class RunController < ApplicationController
  def execute
    begin
      machine = Machine.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      render json: { error: 'Машина не найдена.' }, status: :not_found
      return
    end

    inputs = params[:inputs]

    if inputs.blank? || !inputs.is_a?(ActionController::Parameters)
      render json: { error: 'Входные данные недействительны или отсутствуют.' }, status: :unprocessable_entity
      return
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
    input_array = inputs.values.map(&:to_i)

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
