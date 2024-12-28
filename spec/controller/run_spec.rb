require "rails_helper"
require "urm/machine"

RSpec.describe RunController, type: :controller do
  let(:valid_machine) do
    Machine.create!(
      name: "Division Machine",
      description: "Machine for integer division",
      input_counts: 2,
      instructions: [
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
    )
  end

  let(:infinite_machine) do
    Machine.create!(
      name: "Infinite Loop Machine",
      description: "Machine that loops indefinitely",
      input_counts: 2,
      instructions: [
        "1. x2 = 9",
        "2. if x2 == 0 goto 6 else goto 3",
        "3. x2 = x2 + 1",
        "4. x1 = x1 + 1",
        "5. if x2 == 0 goto 6 else goto 3",
        "6. stop"
      ]
    )
  end

  describe "POST #execute" do
    it "executes a valid machine and returns the result" do
      post :execute, params: { id: valid_machine.id, inputs: { "x2" => 10, "x3" => 2 } }
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)["output"]).to eq(10 / 2)
    end

    it "returns an error if inputs are invalid" do
      post :execute, params: { id: valid_machine.id, inputs: { "x2" => "invalid", "x3" => 2 } }
      expect(response).to have_http_status(:unprocessable_entity)
      expect(JSON.parse(response.body)["error"]).to include("Ошибка выполнения")
    end

    it "returns a timeout error for an infinite loop" do
      post :execute, params: { id: infinite_machine.id, inputs: { "x2" => 9, "x3" => 0 } }
      expect(response).to have_http_status(:request_timeout)
      expect(JSON.parse(response.body)["error"]).to eq("Время выполнения превысило лимит.")
    end

    it "returns an error if machine does not exist" do
      post :execute, params: { id: 9999, inputs: { "x2" => 10, "x3" => 2 } }
      expect(response).to have_http_status(:not_found)
    end
  end
end
