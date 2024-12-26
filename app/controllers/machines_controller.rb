require "urm/machine"
class MachinesController < ApplicationController

  skip_before_action :verify_authenticity_token, only: [:create]
  def create
    data = JSON.parse(request.body.read)
    machine = Machine.new(
      name: data['name'],
      description: data['description'],
      author: data['author'],
      input_counts: data['input_counts'],
      instructions: data['instructions']
    )


    if machine.save
      render json: { message: 'Machine created successfully', machine: machine }, status: :created
    else
      render json: { errors: machine.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def index
    @machines = Machine.all
  end

  def edit
    @machine = Machine.find(params[:id])
  end

  def show_machine
    @machine = Machine.find(params[:id])
    render json: { name: @machine.name, description: @machine.description }
  end
end
