require "urm/machine"
class MachinesController < ApplicationController

  def create
    data = JSON.parse(request.body.read)
    puts data
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

    if machine.author != current_user.id
      render json: { error: 'У вас нет прав для обновления этой машины.' }, status: :forbidden
      return
    end

    data = JSON.parse(request.body.read)

    if machine.update(data['machine'])
      render json: machine, status: :ok
    else
      render json: { errors: machine.errors.full_messages }, status: :unprocessable_entity
    end
  end


  def destroy

    machine = Machine.find(params[:id])

    if machine.author == current_user.id
      machine.destroy
      render json: { message: 'Машина успешно удалена.' }, status: :ok
    else
      render json: { error: 'У вас нет прав для удаления этой машины.' }, status: :forbidden
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
    @machine = Machine.find(params[:id])

    if @machine.author != current_user.id
      redirect_to machines_path
      return
    end

    @instructions = @machine.instructions
  end


  def show_machine
    @machine = Machine.find(params[:id])
    render json: { name: @machine.name, description: @machine.description }
  end
end
