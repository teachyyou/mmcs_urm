# frozen_string_literal: true

require "urm/machine"
require "urm/instruction"
require "urm/exceptions"
require "urm/machine_tester"

RSpec.describe "MachineTester Operations" do
  describe "Basic Arithmetic Operations" do
    it "tests multiplication" do
      multiplication_instructions = [
        "1. if x3 == 0 goto 9 else goto 2",
        "2. x3 = x3 - 1",
        "3. x4 = x2",
        "4. if x4 == 0 goto 8 else goto 5",
        "5. x1 = x1 + 1",
        "6. x4 = x4 - 1",
        "7. if x4 == 0 goto 8 else goto 5",
        "8. if x3 == 0 goto 9 else goto 2",
        "9. stop"
      ]

      machine = Urm::Machine.new(2)
      machine.add_all(multiplication_instructions)

      expect(MachineTester.assert_range(machine, 0, 10, ->(x2, x3) { x2 * x3 })).to be_truthy
    end

    it "tests division" do
      division_instructions = [
        "1. if x2 == 0 goto 10 else goto 2",
        "2. x4 = x3",
        "3. x2 = x2 - 1",
        "4. x4 = x4 - 1",
        "5. if x2 == 0 goto 6 else goto 7",
        "6. if x4 == 0 goto 8 else goto 10",
        "7. if x4 == 0 goto 8 else goto 3",
        "8. x1 = x1 + 1",
        "9. if x2 == 0 goto 10 else goto 2",
        "10. stop"
      ]

      machine = Urm::Machine.new(2)
      machine.add_all(division_instructions)

      expect(MachineTester.assert_range(machine, 1, 10, ->(x2, x3) { x2 / x3 })).to be_truthy
    end

    it "tests subtraction" do
      subtraction_instructions = [
        "1. if x2 == 0 goto 7 else goto 2",
        "2. if x3 == 0 goto 6 else goto 3",
        "3. x2 = x2 - 1",
        "4. x3 = x3 - 1",
        "5. if x2 == 0 goto 7 else goto 2",
        "6. x1 = x2",
        "7. stop"
      ]

      machine = Urm::Machine.new(2)
      machine.add_all(subtraction_instructions)

      expect(MachineTester.assert_range(machine, 0, 100, ->(x2, x3) { [x2 - x3, 0].max })).to be_truthy
    end

    it "tests addition" do
      addition_instructions = [
        "1. if x2 == 0 goto 5 else goto 2",
        "2. x2 = x2 - 1",
        "3. x1 = x1 + 1",
        "4. if x2 == 0 goto 5 else goto 2",
        "5. if x3 == 0 goto 9 else goto 6",
        "6. x3 = x3 - 1",
        "7. x1 = x1 + 1",
        "8. if x3 == 0 goto 9 else goto 6",
        "9. stop"
      ]

      machine = Urm::Machine.new(2)
      machine.add_all(addition_instructions)

      expect(MachineTester.assert_range(machine, 0, 100, ->(x2, x3) { x2 + x3 })).to be_truthy
    end
  end

  describe "Comparison Operations" do
    it "tests minimum" do
      min_instructions = [
        "1. if x2 == 0 goto 8 else goto 2",
        "2. if x3 == 0 goto 8 else goto 3",
        "3. x1 = x1 + 1",
        "4. x2 = x2 - 1",
        "5. x3 = x3 - 1",
        "6. if x2 == 0 goto 8 else goto 7",
        "7. if x3 == 0 goto 8 else goto 3",
        "8. stop"
      ]

      machine = Urm::Machine.new(2)
      machine.add_all(min_instructions)

      expect(MachineTester.assert_range(machine, 0, 100, ->(x2, x3) { [x2, x3].min })).to be_truthy
    end

    it "tests maximum" do
      max_instructions = [
        "1. if x2 == 0 goto 2 else goto 3",
        "2. if x3 == 0 goto 8 else goto 3",
        "3. x1 = x1 + 1",
        "4. x2 = x2 - 1",
        "5. x3 = x3 - 1",
        "6. if x2 == 0 goto 7 else goto 3",
        "7. if x3 == 0 goto 8 else goto 3",
        "8. stop"
      ]

      machine = Urm::Machine.new(2)
      machine.add_all(max_instructions)

      expect(MachineTester.assert_range(machine, 0, 100, ->(x2, x3) { [x2, x3].max })).to be_truthy
    end

    it "tests absolute difference" do
      abs_diff_instructions = [
        "1. if x2 == 0 goto 7 else goto 2",
        "2. if x3 == 0 goto 6 else goto 3",
        "3. x2 = x2 - 1",
        "4. x3 = x3 - 1",
        "5. if x2 == 0 goto 7 else goto 2",
        "6. x1 = x2",
        "7. if x3 == 0 goto 9 else goto 8",
        "8. x1 = x3",
        "9. stop"
      ]

      machine = Urm::Machine.new(2)
      machine.add_all(abs_diff_instructions)

      expect(MachineTester.assert_range(machine, 0, 100, ->(x2, x3) { (x2 - x3).abs })).to be_truthy
    end
  end
end
