# frozen_string_literal: true

require "urm/machine"
require "urm/instruction"
require "urm/exceptions"
require "urm/machine_tester"

RSpec.describe "Simplest Machines" do
  describe "Basic URM Execution" do
    it "executes an empty program" do
      empty_instructions = []
      machine = Urm::Machine.new(1)
      machine.add_all(empty_instructions)

      (0..100).each { |x| expect(machine.run(x)).to eq(0) }
    end

    it "executes a program with only stop instruction" do
      stop_instructions = ["1. stop"]
      machine = Urm::Machine.new(0)
      machine.add_all(stop_instructions)

      (0..100).each { |x| expect(machine.run).to eq(0) }
    end

    it "executes a program with a single set instruction" do
      set_instructions = [
        "1. x1 = 42",
        "2. stop"
      ]
      machine = Urm::Machine.new(1)
      machine.add_all(set_instructions)

      (0..100).each { |x| expect(machine.run(x)).to eq(42) }
    end

    it "executes a program that always returns 3" do
      always_3_instructions = [
        "1. x1 = x1 + 1",
        "2. if x1 == 0 goto 1 else goto 3",
        "3. x1 = 3",
        "4. stop"
      ]
      machine = Urm::Machine.new(1)
      machine.add_all(always_3_instructions)

      (0..100).each { |x| expect(machine.run(x)).to eq(3) }
    end

    it "executes a program that always returns 4" do
      always_4_instructions = [
        "1. if x1 == 0 goto 2 else goto 4",
        "2. x1 = x1 + 1",
        "3. x1 = x1 + 1",
        "4. if x1 == 0 goto 2 else goto 5",
        "5. x1 = x1 + 1",
        "6. x1 = x1 + 1",
        "7. stop"
      ]
      machine = Urm::Machine.new(2)
      machine.add_all(always_4_instructions)

      (0..100).each { |x| expect(machine.run(x, x)).to eq(4) }
    end

    it "executes a program that always returns 1" do
      always_1_instructions = [
        "1. x1 = x1 + 1",
        "2. x1 = x1 + 1",
        "3. if x1 == 0 goto 1 else goto 4",
        "4. x1 = x1 - 1",
        "5. stop"
      ]
      machine = Urm::Machine.new(0)
      machine.add_all(always_1_instructions)

      (0..100).each { |_x| expect(machine.run).to eq(1) }
    end

    it "executes a program that returns identical input" do
      identical_instructions = [
        "1. if x2 == 0 goto 5 else goto 2",
        "2. x1 = x1 + 1",
        "3. x2 = x2 - 1",
        "4. if x2 == 0 goto 5 else goto 2",
        "5. stop"
      ]
      machine = Urm::Machine.new(1)
      machine.add_all(identical_instructions)

      (0..100).each { |x| expect(machine.run(x)).to eq(x) }
    end

    it "executes a program that increments input" do
      inc_instructions = [
        "1. if x1 == 0 goto 2 else goto 3",
        "2. x1 = 1",
        "3. if x2 == 0 goto 7 else goto 4",
        "4. x1 = x1 + 1",
        "5. x2 = x2 - 1",
        "6. if x2 == 0 goto 7 else goto 4",
        "7. stop"
      ]
      machine = Urm::Machine.new(1)
      machine.add_all(inc_instructions)

      (0..100).each { |x| expect(machine.run(x)).to eq(x + 1) }
    end

    it "executes a program with useless input" do
      useless_instructions = [
        "1. x1 = 1",
        "2. if x2 == 0 goto 3 else goto 5",
        "3. x2 = x2 + 1",
        "4. x2 = x2 - 1",
        "5. stop"
      ]
      machine = Urm::Machine.new(1)
      machine.add_all(useless_instructions)

      (0..100).each { |x| expect(machine.run(x)).to eq(1) }
    end

    it "executes a program with bigger useless input" do
      bigger_useless_instructions = [
        "1. if x2 == 0 goto 2 else goto 3",
        "2. if x3 == 0 goto 3 else goto 4",
        "3. x2 = x2 + 1",
        "4. x1 = 3",
        "5. stop"
      ]
      machine = Urm::Machine.new(2)
      machine.add_all(bigger_useless_instructions)

      (0..100).each do |x|
        (0..100).each { |y| expect(machine.run(x, y)).to eq(3) }
      end
    end
  end
end
