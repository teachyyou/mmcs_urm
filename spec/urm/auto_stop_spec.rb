# frozen_string_literal: true

require "urm/machine"
require "urm/instruction"
require "urm/exceptions"

RSpec.describe "Auto Stop Machines" do
  context "when stop instruction is not added manually" do
    it "adds a stop instruction automatically" do
      instructions = [
        "1. x1 = 1"
      ]

      machine = Urm::Machine.new(0)
      machine.add_all(instructions)

      (0..100).each do |_x|
        expect(machine.run).to eq(1)
      end
    end

    it "adds a stop instruction automatically with an if statement" do
      instructions = [
        "1. x1 = 1",
        "2. if x1 == 0 goto 3 else goto 4",
        "3. x1 = x1 + 1"
      ]

      machine = Urm::Machine.new(0)
      machine.add_all(instructions)

      (0..100).each do |_x|
        expect(machine.run).to eq(1)
      end
    end

    it "adds a stop instruction automatically with a loop" do
      instructions = [
        "1. x1 = 1",
        "2. if x1 == 0 goto 3 else goto 4",
        "3. x1 = x1 + 1",
        "4. if x1 == 0 goto 2 else goto 5"
      ]

      machine = Urm::Machine.new(0)
      machine.add_all(instructions)

      (0..100).each do |_x|
        expect(machine.run).to eq(1)
      end
    end
  end
end
