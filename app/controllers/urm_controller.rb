class UrmController < ApplicationController
  def index
    limit = params[:limit]&.to_i || 10
    offset = params[:offset]&.to_i || 0

    machines = Machine.limit(limit).offset(offset)

    render json: {
      machines: machines.map do |machine|
        {
          uuid: machine.id,
          name: machine.name,
          description: machine.description,
          inputs_count: machine.input_counts,
          author: machine.author,
          created_at: machine.created_at.iso8601,
          updated_at: machine.updated_at.iso8601,
          archived_at: machine.archived_at&.iso8601,
          instructions: machine.instructions
        }
      end,
      totalCount: Machine.count
    }
  end
end
