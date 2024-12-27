class RunController < ApplicationController
  def show
    @machine = Machine.find(params[:id])

    if @machine.nil?
      redirect_to machines_path and return
    end

    @name = @machine.name
    @description = @machine.description
    @instructions = @machine.instructions
    @input_counts = @machine.input_counts.to_i
  end

  def execute
    machine = Machine.find(params[:id])
    inputs = params[:inputs]

    Rails.logger.info "Запущена машина #{machine.id} с входными данными: #{inputs}"

    result = nil
    error = nil

    machine_worker = Urm::Machine.new(machine.input_counts)
    machine_worker.add_all(machine.instructions)
    input_array = inputs.values.map(&:to_i)

    # Создаём поток для выполнения кода
    worker_thread = Thread.new do
      begin
        result = machine_worker.run(*input_array)
        puts "lalala"
        puts *input_array
        puts result
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
