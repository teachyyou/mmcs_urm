# frozen_string_literal: true

require "spec_helper"
require "urm/machine"
require "urm/instruction"
require "urm/exceptions"

RSpec.describe "Invalid Machines" do
  let(:machine) { Urm::Machine.new(register_count) }
  let(:register_count) { 1 }

  context "when multiple stop instructions are present" do
    it "raises Urm::MultipleStopsError for two stops only" do
      instructions = [
        "1. stop",
        "2. stop"
      ]

      machine.add_all(instructions)

      expect { machine.run }.to raise_error(Urm::MultipleStopsError)
    end

    it "raises Urm::MultipleStopsError for two stops among valid instructions" do
      instructions = [
        "1. x1 = 1",
        "2. x1 = x1 + 1",
        "3. stop",
        "4. x1 = x1 + 1",
        "5. stop"
      ]

      machine.add_all(instructions)

      expect { machine.run }.to raise_error(Urm::MultipleStopsError)
    end
  end

  context "when labels are invalid" do
    it "raises Urm::InvalidLabel for missing label in goto" do
      instructions = [
        "1. x1 = 1",
        "2. if x1 == 0 goto 5 else goto 3",
        "3. x1 = x1 + 1",
        "4. stop"
      ]

      machine.add_all(instructions)

      expect { machine.run }.to raise_error(Urm::InvalidLabel)
    end

    it "raises Urm::InvalidLabel for missing label in conditional goto" do
      instructions = [
        "1. x1 = 1",
        "2. if x1 == 0 goto 3 else goto 5", # Label 5 does not exist
        "3. x1 = x1 + 1",
        "4. stop"
      ]

      machine.add_all(instructions)

      expect { machine.run }.to raise_error(Urm::InvalidLabel)
    end

    it "raises Urm::InvalidLabel for missing labels in a loop" do
      instructions = [
        "1. x1 = 1",
        "2. if x1 == 0 goto 3 else goto 4",
        "3. x1 = x1 + 1",
        "4. if x1 == 0 goto 6 else goto 2", # Label 6 does not exist
        "5. stop"
      ]

      machine.add_all(instructions)

      expect { machine.run }.to raise_error(Urm::InvalidLabel)
    end

    it "raises Urm::InvalidLabel for missing label in goto with arithmetic instruction" do
      instructions = [
        "1. x1 = 1",
        "2. x1 = x1 + 1",
        "3. if x1 == 0 goto 4 else goto 6",
        "4. stop"
      ]

      machine.add_all(instructions)

      expect { machine.run }.to raise_error(Urm::InvalidLabel)
    end
  end
end
