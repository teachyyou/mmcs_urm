require "urm/machine"
class MachinesController < ApplicationController

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
      render json: machine, status: :created
    else
      render json: { errors: machine.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    machine = Machine.find(params[:id])
    data = JSON.parse(request.body.read)
    if machine.update(data['machine'])
      render json: machine, status: :ok
    else
      render json: { errors: machine.errors.full_messages }, status: :unprocessable_entity
    end

  end

  def index
    @machines = Machine.all
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: { machines: @machines } }
    end
  end
  def edit_machine
    puts "gogogo"
    @machine = Machine.find(params[:id])
    puts "lala"
    puts @machine.name
    @instructions = @machine.instructions
  end

  def show_machine
    @machine = Machine.find(params[:id])
    render json: { name: @machine.name, description: @machine.description }
  end
end
