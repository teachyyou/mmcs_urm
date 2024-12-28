# frozen_string_literal: true

require "urm/coder"
require "urm/instruction"
require "urm/machine"

RSpec.describe "Decoding Tests" do
  it "decodes a set instruction" do
    godel_number = Urm::Coder.godel_code([1, 1, 1, 42])
    instruction = Urm::Coder.decode_single_instruction(godel_number)
    expect(instruction.type).to eq(:set)
    expect(instruction.label).to eq(1)
    expect(instruction.register).to eq(1)
    expect(instruction.value).to eq(42)
  end

  it "decodes an inc instruction" do
    godel_number = Urm::Coder.godel_code([2, 2, 1])
    instruction = Urm::Coder.decode_single_instruction(godel_number)
    expect(instruction.type).to eq(:inc)
    expect(instruction.label).to eq(2)
    expect(instruction.register).to eq(1)
  end

  it "decodes a dec instruction" do
    godel_number = Urm::Coder.godel_code([3, 3, 1])
    instruction = Urm::Coder.decode_single_instruction(godel_number)
    expect(instruction.type).to eq(:dec)
    expect(instruction.label).to eq(3)
    expect(instruction.register).to eq(1)
  end

  it "decodes an if instruction" do
    godel_number = Urm::Coder.godel_code([4, 4, 1, 5, 6])
    instruction = Urm::Coder.decode_single_instruction(godel_number)
    expect(instruction.type).to eq(:if)
    expect(instruction.label).to eq(4)
    expect(instruction.register).to eq(1)
    expect(instruction.label_true).to eq(5)
    expect(instruction.label_false).to eq(6)
  end

  it "decodes a stop instruction" do
    godel_number = Urm::Coder.godel_code([5, 7])
    instruction = Urm::Coder.decode_single_instruction(godel_number)
    expect(instruction.type).to eq(:stop)
    expect(instruction.label).to eq(7)
  end

  it "decodes a machine" do
    machine = Urm::Machine.new(2)
    machine.add(Urm::Instruction.set(1, 1, 42))
    machine.add(Urm::Instruction.inc(2, 1))
    machine.add(Urm::Instruction.dec(3, 1))
    machine.add(Urm::Instruction.if(4, 1, 2, 5))
    machine.add(Urm::Instruction.stop(7))

    encoded_machine = Urm::Coder.code_machine(machine)
    decoded_machine = Urm::Coder.decode_machine(encoded_machine)

    expect(decoded_machine.instructions.compact.size).to eq(5)

    instructions = decoded_machine.instructions.compact

    expect(instructions[0].type).to eq(:set)
    expect(instructions[0].label).to eq(1)
    expect(instructions[0].register).to eq(1)
    expect(instructions[0].value).to eq(42)

    expect(instructions[1].type).to eq(:inc)
    expect(instructions[1].label).to eq(2)
    expect(instructions[1].register).to eq(1)

    expect(instructions[2].type).to eq(:dec)
    expect(instructions[2].label).to eq(3)
    expect(instructions[2].register).to eq(1)

    expect(instructions[3].type).to eq(:if)
    expect(instructions[3].label).to eq(4)
    expect(instructions[3].register).to eq(1)
    expect(instructions[3].label_true).to eq(2)
    expect(instructions[3].label_false).to eq(5)

    expect(instructions[4].type).to eq(:stop)
    expect(instructions[4].label).to eq(7)
  end

  it "decodes machine with parsed instructions" do
    instructions = [
      "1. x1 = 3",
      "2. if x2 == 0 goto 6 else goto 3",
      "3. x2 = x2 + 1",
      "4. x1 = x1 - 1",
      "5. if x1 == 0 goto 6 else goto 3",
      "6. stop"
    ]

    machine = Urm::Machine.new(1)
    machine.add_all(instructions)

    encoded_machine = Urm::Coder.code_machine(machine)
    decoded_machine = Urm::Coder.decode_machine(encoded_machine)

    expect(decoded_machine.instructions.compact.size).to eq(6)

    decoded_instructions = decoded_machine.instructions.compact

    expect(decoded_instructions[0].type).to eq(:set)
    expect(decoded_instructions[0].label).to eq(1)
    expect(decoded_instructions[0].register).to eq(1)
    expect(decoded_instructions[0].value).to eq(3)

    expect(decoded_instructions[1].type).to eq(:if)
    expect(decoded_instructions[1].label).to eq(2)
    expect(decoded_instructions[1].register).to eq(2)
    expect(decoded_instructions[1].label_true).to eq(6)
    expect(decoded_instructions[1].label_false).to eq(3)

    expect(decoded_instructions[2].type).to eq(:inc)
    expect(decoded_instructions[2].label).to eq(3)
    expect(decoded_instructions[2].register).to eq(2)

    expect(decoded_instructions[3].type).to eq(:dec)
    expect(decoded_instructions[3].label).to eq(4)
    expect(decoded_instructions[3].register).to eq(1)

    expect(decoded_instructions[4].type).to eq(:if)
    expect(decoded_instructions[4].label).to eq(5)
    expect(decoded_instructions[4].register).to eq(1)
    expect(decoded_instructions[4].label_true).to eq(6)
    expect(decoded_instructions[4].label_false).to eq(3)

    expect(decoded_instructions[5].type).to eq(:stop)
    expect(decoded_instructions[5].label).to eq(6)
  end

  it "decodes similar machines" do
    machine1 = Urm::Machine.new(1)
    machine1.add(Urm::Instruction.if(1, 2, 2, 2))
    machine1.add(Urm::Instruction.parse("2. stop"))

    machine2 = Urm::Machine.new(1)
    machine2.add(Urm::Instruction.if(1, 2, 2, 2))

    encoded_machine1 = Urm::Coder.code_machine(machine1)
    decoded_machine1 = Urm::Coder.decode_machine(encoded_machine1)

    encoded_machine2 = Urm::Coder.code_machine(machine2)
    decoded_machine2 = Urm::Coder.decode_machine(encoded_machine2)

    expect(decoded_machine2.instructions.size).to eq(decoded_machine1.instructions.compact.size)

    decoded_instructions1 = decoded_machine1.instructions.compact
    decoded_instructions2 = decoded_machine2.instructions.compact

    expect(decoded_instructions1[0].type).to eq(decoded_instructions2[0].type)
    expect(decoded_instructions1[0].label).to eq(decoded_instructions2[0].label)
    expect(decoded_instructions1[0].register).to eq(decoded_instructions2[0].register)
    expect(decoded_instructions1[0].label_false).to eq(decoded_instructions2[0].label_false)
    expect(decoded_instructions1[0].label_true).to eq(decoded_instructions2[0].label_true)
  end
end
