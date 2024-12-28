# frozen_string_literal: true

require "urm/instruction"
require "urm/exceptions"

RSpec.describe "Instruction Tests" do
  context "Set Instruction" do
    it "creates a valid set instruction" do
      inst = Urm::Instruction.set(1, 2, 3)
      expect(inst.label).to eq(1)
      expect(inst.type).to eq(:set)
      expect(inst.register).to eq(2)
      expect(inst.value).to eq(3)
    end

    it "raises an error for invalid value" do
      expect { Urm::Instruction.set(1, 2, -1) }.to raise_error(Urm::InvalidRegisterInitialization)
    end

    it "raises an error for invalid register" do
      expect { Urm::Instruction.set(1, 0, 3) }.to raise_error(Urm::InvalidRegisterIndex)
    end

    it "raises an error for invalid label" do
      expect { Urm::Instruction.set(0, 2, 3) }.to raise_error(Urm::InvalidLabel)
      expect { Urm::Instruction.set(-1, 2, 3) }.to raise_error(Urm::InvalidLabel)
    end
  end

  context "Increment Instruction" do
    it "creates a valid increment instruction" do
      inst = Urm::Instruction.inc(1, 2)
      expect(inst.label).to eq(1)
      expect(inst.type).to eq(:inc)
      expect(inst.register).to eq(2)
    end

    it "raises an error for invalid register" do
      expect { Urm::Instruction.inc(1, 0) }.to raise_error(Urm::InvalidRegisterIndex)
    end

    it "raises an error for invalid label" do
      expect { Urm::Instruction.inc(0, 2) }.to raise_error(Urm::InvalidLabel)
      expect { Urm::Instruction.inc(-1, 2) }.to raise_error(Urm::InvalidLabel)
    end
  end

  context "Decrement Instruction" do
    it "creates a valid decrement instruction" do
      inst = Urm::Instruction.dec(1, 2)
      expect(inst.label).to eq(1)
      expect(inst.type).to eq(:dec)
      expect(inst.register).to eq(2)
    end

    it "raises an error for invalid register" do
      expect { Urm::Instruction.dec(1, 0) }.to raise_error(Urm::InvalidRegisterIndex)
    end

    it "raises an error for invalid label" do
      expect { Urm::Instruction.dec(0, 2) }.to raise_error(Urm::InvalidLabel)
      expect { Urm::Instruction.dec(-1, 2) }.to raise_error(Urm::InvalidLabel)
    end
  end

  context "If Instruction" do
    it "creates a valid if instruction" do
      inst = Urm::Instruction.if(1, 2, 3, 4)
      expect(inst.label).to eq(1)
      expect(inst.type).to eq(:if)
      expect(inst.register).to eq(2)
      expect(inst.label_true).to eq(3)
      expect(inst.label_false).to eq(4)
    end

    it "raises an error for invalid register" do
      expect { Urm::Instruction.if(1, 0, 3, 4) }.to raise_error(Urm::InvalidRegisterIndex)
    end

    it "raises an error for invalid label" do
      expect { Urm::Instruction.if(0, 2, 3, 4) }.to raise_error(Urm::InvalidLabel)
      expect { Urm::Instruction.if(-1, 2, 3, 4) }.to raise_error(Urm::InvalidLabel)
      expect { Urm::Instruction.if(1, 2, 0, 4) }.to raise_error(Urm::InvalidLabel)
      expect { Urm::Instruction.if(1, 2, 3, 0) }.to raise_error(Urm::InvalidLabel)
    end
  end

  context "Stop Instruction" do
    it "creates a valid stop instruction" do
      inst = Urm::Instruction.stop(1)
      expect(inst.label).to eq(1)
      expect(inst.type).to eq(:stop)
    end

    it "raises an error for invalid label" do
      expect { Urm::Instruction.stop(0) }.to raise_error(Urm::InvalidLabel)
      expect { Urm::Instruction.stop(-1) }.to raise_error(Urm::InvalidLabel)
    end
  end

  context "Copy Instruction" do
    it "creates a valid copy instruction" do
      inst = Urm::Instruction.copy(1, 2, 3)
      expect(inst.label).to eq(1)
      expect(inst.type).to eq(:copy)
      expect(inst.register).to eq(2)
      expect(inst.value).to eq(3)
    end

    it "raises an error for invalid register" do
      expect { Urm::Instruction.copy(1, 0, 3) }.to raise_error(Urm::InvalidRegisterIndex)
      expect { Urm::Instruction.copy(1, 2, 0) }.to raise_error(Urm::InvalidRegisterIndex)
    end

    it "raises an error for invalid label" do
      expect { Urm::Instruction.copy(0, 2, 3) }.to raise_error(Urm::InvalidLabel)
      expect { Urm::Instruction.copy(-1, 2, 3) }.to raise_error(Urm::InvalidLabel)
    end
  end
end
