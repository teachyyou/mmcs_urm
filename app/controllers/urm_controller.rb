class UrmController < ApplicationController

  class Machine
    attr_accessor :name, :description

    def initialize(name, description = "description")
      @name = name
      @description = description
    end

  end
  def index
    @machines = [
      Machine.new(name: "machine1"),
      Machine.new(name: "machine2"),
      Machine.new(name: "machine3")
    ]
    @selected_machine = Machine.new("machine","this is the description")
  end


end


