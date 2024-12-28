# frozen_string_literal: true

require "urm/instruction"
require "urm/exceptions"

RSpec.describe "Instruction Parsing Tests" do
  describe "Parsing Instructions" do
    it "parses a valid set instruction" do
      inst = Urm::Instruction.parse("1. x2 = 3")
      expect(inst.label).to eq(1)
      expect(inst.type).to eq(:set)
      expect(inst.register).to eq(2)
      expect(inst.value).to eq(3)
    end

    it "parses a valid increment instruction" do
      inst = Urm::Instruction.parse("1. x2 = x2 + 1")
      expect(inst.label).to eq(1)
      expect(inst.type).to eq(:inc)
      expect(inst.register).to eq(2)
    end

    it "parses a valid decrement instruction" do
      inst = Urm::Instruction.parse("1. x3 = x3 - 1")
      expect(inst.label).to eq(1)
      expect(inst.type).to eq(:dec)
      expect(inst.register).to eq(3)
    end

    it "parses a valid if instruction" do
      inst = Urm::Instruction.parse("1. if x2 == 0 goto 3 else goto 4")
      expect(inst.label).to eq(1)
      expect(inst.type).to eq(:if)
      expect(inst.register).to eq(2)
      expect(inst.label_true).to eq(3)
      expect(inst.label_false).to eq(4)
    end

    it "parses a valid stop instruction" do
      inst = Urm::Instruction.parse("1. stop")
      expect(inst.label).to eq(1)
      expect(inst.type).to eq(:stop)
    end

    it "parses a valid copy instruction" do
      inst = Urm::Instruction.parse("1. x2 = x3")
      expect(inst.label).to eq(1)
      expect(inst.type).to eq(:copy)
      expect(inst.register).to eq(2)
      expect(inst.value).to eq(3)
    end
  end

  describe "Invalid Instructions" do
    it "raises error for invalid set value" do
      expect { Urm::Instruction.parse("1. x2 = -1") }.to raise_error(Urm::InvalidRegisterInitialization)
    end

    it "raises error for invalid set register" do
      expect { Urm::Instruction.parse("1. x0 = 3") }.to raise_error(Urm::InvalidRegisterIndex)
    end

    it "raises error for invalid set label" do
      expect { Urm::Instruction.parse("0. x2 = 3") }.to raise_error(Urm::InvalidLabel)
      expect { Urm::Instruction.parse("-1. x2 = 3") }.to raise_error(Urm::InvalidLabel)
    end

    it "raises error for invalid increment register" do
      expect { Urm::Instruction.parse("1. x0 = x0 + 1") }.to raise_error(Urm::InvalidRegisterIndex)
    end

    it "raises error for invalid increment label" do
      expect { Urm::Instruction.parse("0. x2 = x2 + 1") }.to raise_error(Urm::InvalidLabel)
      expect { Urm::Instruction.parse("-1. x2 = x2 + 1") }.to raise_error(Urm::InvalidLabel)
    end

    it "raises error for invalid decrement register" do
      expect { Urm::Instruction.parse("1. x0 = x0 - 1") }.to raise_error(Urm::InvalidRegisterIndex)
    end

    it "raises error for invalid decrement label" do
      expect { Urm::Instruction.parse("0. x3 = x3 - 1") }.to raise_error(Urm::InvalidLabel)
    end

    it "raises error for invalid if register" do
      expect { Urm::Instruction.parse("1. if x0 == 0 goto 3 else goto 4") }.to raise_error(Urm::InvalidRegisterIndex)
    end

    it "raises error for invalid if labels" do
      expect { Urm::Instruction.parse("0. if x2 == 0 goto 3 else goto 4") }.to raise_error(Urm::InvalidLabel)
      expect { Urm::Instruction.parse("-1. if x2 == 0 goto 3 else goto 4") }.to raise_error(Urm::InvalidLabel)
      expect { Urm::Instruction.parse("1. if x2 == 0 goto 0 else goto 4") }.to raise_error(Urm::InvalidLabel)
      expect { Urm::Instruction.parse("1. if x2 == 0 goto 3 else goto 0") }.to raise_error(Urm::InvalidLabel)
    end

    it "raises error for invalid stop label" do
      expect { Urm::Instruction.parse("0. stop") }.to raise_error(Urm::InvalidLabel)
      expect { Urm::Instruction.parse("-1. stop") }.to raise_error(Urm::InvalidLabel)
    end

    it "raises error for invalid copy register" do
      expect { Urm::Instruction.parse("1. x0 = x3") }.to raise_error(Urm::InvalidRegisterIndex)
      expect { Urm::Instruction.parse("1. x2 = x0") }.to raise_error(Urm::InvalidRegisterIndex)
    end

    it "raises error for invalid copy label" do
      expect { Urm::Instruction.parse("0. x2 = x3") }.to raise_error(Urm::InvalidLabel)
      expect { Urm::Instruction.parse("-1. x2 = x3") }.to raise_error(Urm::InvalidLabel)
    end
  end

  describe "String Conversion" do
    it "converts set instruction to string" do
      inst = Urm::Instruction.set(1, 2, 3)
      expect(inst.to_s).to eq("1. x2 = 3")
    end

    it "converts increment instruction to string" do
      inst = Urm::Instruction.inc(1, 2)
      expect(inst.to_s).to eq("1. x2 = x2 + 1")
    end

    it "converts decrement instruction to string" do
      inst = Urm::Instruction.dec(1, 3)
      expect(inst.to_s).to eq("1. x3 = x3 - 1")
    end

    it "converts if instruction to string" do
      inst = Urm::Instruction.if(1, 2, 3, 4)
      expect(inst.to_s).to eq("1. if x2 == 0 goto 3 else goto 4")
    end

    it "converts stop instruction to string" do
      inst = Urm::Instruction.stop(1)
      expect(inst.to_s).to eq("1. stop")
    end

    it "converts copy instruction to string" do
      inst = Urm::Instruction.copy(1, 2, 3)
      expect(inst.to_s).to eq("1. x2 = x3")
    end
  end
end
