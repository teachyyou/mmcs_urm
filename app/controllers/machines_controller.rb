require "urm/machine"
class MachinesController < ApplicationController

  before_action :authenticate_user!, except: [:index, :show_machine]
  before_action :authorize_machine_author, only: [:edit_machine, :destroy]

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
    machine.destroy
    redirect_to machines_path
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
    @instructions = @machine.instructions
  end
  def show_machine
    @machine = Machine.find(params[:id])
    render json: { name: @machine.name, description: @machine.description }
  end

  private

  def authenticate_user!
    unless current_user
      redirect_to new_user_session_path
    end
  end

  def authorize_machine_author
    machine = Machine.find_by(id: params[:id])

    if machine.nil?
      redirect_to machines_path and return
    end

    unless machine.author == current_user.id
      redirect_to machines_path
    end
  end


end
