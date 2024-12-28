require 'rails_helper'
require "urm/machine"

RSpec.describe Machine, type: :model do
  describe "validations and operations" do
    let(:machine_data) do
      {
        name: "Test Machine",
        description: "A machine for testing",
        input_counts: "2",
        instructions: [
          "1. x1 = 1",
          "2. if x1 == 0 goto 4 else goto 3",
          "3. x1 = x1 + 1",
          "4. stop"
        ],
        author: "test_author"
      }
    end

    let(:machine_object) do
      Urm::Machine.new(machine_data[:input_counts].to_i).tap do |machine|
        machine.add_all(machine_data[:instructions].map(&:to_s))
      end
    end

    it "creates a Machine object from view data" do

      expect { machine_object }.not_to raise_error
      expect(machine_object.instructions.compact.size).to eq(machine_data[:instructions].size)
    end

    it "executes instructions from the machine's data" do

      result = machine_object.run(0, 0)
      expect(result).to eq(1)
    end

    it "validates machine's instructions separately" do
      machine_data[:instructions].each do |instruction|
        urm_instruction = Urm::Instruction.parse(instruction)
        expect(urm_instruction).to be_a(Urm::Instruction)
      end
    end
  end
end
