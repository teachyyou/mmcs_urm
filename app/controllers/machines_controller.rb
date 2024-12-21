class MachinesController < ApplicationController

  def create
    data = JSON.parse(request.body.read)
    machine = Machine.new(
      name: data['name'],
      description: data['description'],
      author: data['author'],
      input_counts: data['input_counts'],
      instructions: data['instructions'].to_json
    )

    if machine.save
      render json: { message: 'Machine created successfully', machine: machine }, status: :created
    else
      render json: { errors: machine.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def index
    @machines = Machine.all
    #render json: @machines
  end

  def show_machine
    @machine = Machine.find(params[:id])
    render json: { name: @machine.name, description: @machine.description }
  end
end
