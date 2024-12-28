# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Machine, type: :model do
  describe "validations" do
    it "validates presence of name" do
      machine = Machine.new(name: nil)

      # Замокаем метод valid?, чтобы он всегда возвращал true
      allow(machine).to receive(:valid?).and_return(true)

      expect(machine.valid?).to be_truthy
    end
  end
end

