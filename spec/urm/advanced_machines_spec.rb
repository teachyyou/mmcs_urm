# frozen_string_literal: true

require "spec_helper"
require "urm/machine"
require "urm/instruction"
require "urm/exceptions"
require "urm/machine_tester"

RSpec.describe "Advanced Machines" do
  let(:machine) { Urm::Machine.new(register_count) }
  let(:register_count) { 2 }

  describe "Arithmetic Operations" do
    it "computes the sum without copying" do
      sum_instructions = [
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

      machine.add_all(sum_instructions)

      (0..100).each do |x|
        (0..100).each do |y|
          expect(machine.run(x, y)).to eq(x + y)
        end
      end
    end

    it "computes the sum with copying" do
      sum_instructions = [
        "1. x1 = x2",
        "2. if x3 == 0 goto 6 else goto 3",
        "3. x1 = x1 + 1",
        "4. x3 = x3 - 1",
        "5. if x3 == 0 goto 6 else goto 3",
        "6. stop"
      ]

      machine.add_all(sum_instructions)

      (0..100).each do |x|
        (0..100).each do |y|
          expect(machine.run(x, y)).to eq(x + y)
        end
      end
    end

    it "computes the subtraction with copying" do
      subtraction_instructions = [
        "1. x1 = x2",
        "2. if x3 == 0 goto 6 else goto 3",
        "3. x1 = x1 - 1",
        "4. x3 = x3 - 1",
        "5. if x3 == 0 goto 6 else goto 3",
        "6. stop"
      ]

      machine.add_all(subtraction_instructions)

      (0..100).each do |x|
        (0..100).each do |y|
          expect(machine.run(x, y)).to eq([x - y, 0].max)
        end
      end
    end

    it "computes the multiplication" do
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

      machine.add_all(multiplication_instructions)

      (0..20).each do |x|
        (0..20).each do |y|
          expect(machine.run(x, y)).to eq(x * y)
        end
      end
    end

    it "computes the division" do
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

      machine.add_all(division_instructions)

      (0..100).each do |x|
        (1..100).each do |y|
          expect(machine.run(x, y)).to eq(x / y)
        end
      end
    end
  end

  describe "Min/Max and Absolute Difference" do
    it "computes the minimum" do
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

      machine.add_all(min_instructions)

      (0..100).each do |x|
        (0..100).each do |y|
          expect(machine.run(x, y)).to eq([x, y].min)
        end
      end
    end

    it "computes the maximum" do
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

      machine.add_all(max_instructions)

      (0..100).each do |x|
        (0..100).each do |y|
          expect(machine.run(x, y)).to eq([x, y].max)
        end
      end
    end

    it "computes the absolute difference" do
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

      machine.add_all(abs_diff_instructions)

      (0..100).each do |x|
        (0..100).each do |y|
          expect(machine.run(x, y)).to eq((x - y).abs)
        end
      end
    end
  end
end
