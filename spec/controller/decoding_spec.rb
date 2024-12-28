require 'rails_helper'

RSpec.describe DecodeController, type: :controller do
  describe "POST #execute" do
    let(:valid_encoded_machine) { [308700, 26575698996000, 16200] } # Пример закодированной машины
    let(:decoded_instructions) { ["1. x1 = 2", "2. if x2 == 0 goto 4 else goto 3", "3. x1 = x1 + 1"] }

    before do
      allow(Urm::Coder).to receive(:decode_machine).and_return(
        double('Machine', instructions: decoded_instructions.map { |i| double(to_s: i) })
      )
    end

    context "when encoded_machine is provided and valid" do
      it "returns decoded instructions" do
        post :execute, params: { encoded_machine: valid_encoded_machine }

        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)).to eq({ "instructions" => decoded_instructions })
      end
    end

    context "when encoded_machine is missing" do
      it "returns an error message" do
        post :execute, params: { encoded_machine: nil }

        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)).to eq({ "error" => "Закодированные данные не предоставлены." })
      end
    end

    context "when decoding fails" do
      before do
        allow(Urm::Coder).to receive(:decode_machine).and_raise(StandardError.new("Invalid encoding"))
      end

      it "returns an error message" do
        post :execute, params: { encoded_machine: valid_encoded_machine }

        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)).to eq({ "error" => "Ошибка декодирования: Invalid encoding" })
      end
    end
  end
end
