# frozen_string_literal: true

class MachinesController < ApplicationController
  


  skip_before_action :verify_authenticity_token, only: [:create]

  def create  #todo заблокировать сохранение машин с пустыми строками
    # Парсинг JSON из тела запроса
    begin
      data = JSON.parse(request.body.read)

      # Создание нового объекта Car с данными из JSON
      machine = Machine.new(
        name: data['name'],
        description: data['description'],
        author: data['author'],
        input_counts: data['input_counts'],
        instructions: data['instructions'].to_json # Сохраняем массив как JSON
      )

      if machine.save
        render json: { message: 'Machine created successfully', machine: machine }, status: :created
      else
        render json: { errors: machine.errors.full_messages }, status: :unprocessable_entity
      end
    rescue JSON::ParserError => e
      render json: { error: 'Invalid JSON format' }, status: :unprocessable_entity
    end
  end

  def index
    limit = params[:limit]&.to_i || 10
    offset = params[:offset]&.to_i || 0

    @machines = Machine.all#.limit(limit).offset(offset)
    
    # render json: {
    #   machines: machines.map do |machine|
    #     {
    #       uuid: machine.id,
    #       name: machine.name,
    #       description: machine.description,
    #       inputs_count: machine.input_counts,
    #       author: machine.author,
    #       created_at: machine.created_at.iso8601,
    #       updated_at: machine.updated_at.iso8601,
    #       archived_at: machine.archived_at&.iso8601,
    #       instructions: machine.instructions
    #     }
    #   end,
    #   totalCount: Machine.count
    # }
  end

  def show_machine
    @machine = Machine.find(params[:id])
    @selected_machine_id = params[:id]
    render json: { name: @machine.name, description: @machine.description }
  end

  def add_new_machine
    # if @selected_machine_id 
    #   @machine = Machine.find(params[:id])
    #   render json: {
    #     uuid: machine.id,
    #     name: machine.name,
    #     description: machine.description,
    #     inputs_count: machine.input_counts,
    #     author: machine.author,
    #     created_at: machine.created_at.iso8601,
    #     updated_at: machine.updated_at.iso8601,
    #     archived_at: machine.archived_at&.iso8601,
    #     instructions: machine.instructions
    #   }
    # end

    # render json: { name: @machine.name, description: @machine.description }

  end
end
