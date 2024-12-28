# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Machine, type: :model do
  describe "validations" do
    it "validates presence of name" do
      machine = Machine.new(name: nil)
      expect(machine.valid?).to be_falsey
      expect(machine.errors[:name]).to include("can't be blank")
    end
  end
end
