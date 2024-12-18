# frozen_string_literal: true

class MachinesController < ApplicationController
  def add_new_machine

  end

  skip_before_action :verify_authenticity_token, only: [:create]

  def create
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
end
