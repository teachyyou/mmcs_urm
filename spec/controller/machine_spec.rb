require "rails_helper"

RSpec.describe MachinesController, type: :controller do
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }
  let(:valid_attributes) do
    {
      name: "Test Machine",
      description: "A test machine",
      author: user.id,
      input_counts: 2,
      instructions: ["1. x1 = 1", "2. stop"]
    }
  end

  let(:invalid_attributes) do
    {
      name: "",
      description: "",
      input_counts: -1,
      instructions: []
    }
  end

  before do
    sign_in user
  end

  describe "GET #index" do
    it "returns a success response with machines" do
      machine = Machine.create!(valid_attributes)
      get :index, format: :json
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)["machines"].first["name"]).to eq(machine.name)
    end
  end

  describe "GET #show_machine" do
    it "returns the machine details" do
      machine = Machine.create!(valid_attributes)
      get :show_machine, params: { id: machine.id }
      expect(response).to have_http_status(:ok)
      parsed_response = JSON.parse(response.body)
      expect(parsed_response["name"]).to eq(machine.name)
      expect(parsed_response["description"]).to eq(machine.description)
    end
  end

  describe "POST #create" do
    context "with valid parameters" do
      it "creates a new Machine" do
        expect do
          post :create, body: valid_attributes.to_json, as: :json
        end.to change(Machine, :count).by(1)
        expect(response).to have_http_status(:created)
      end
    end

    context "with invalid parameters" do
      it "returns unprocessable entity" do
        post :create, body: invalid_attributes.to_json, as: :json
        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)["errors"]).to be_present
      end
    end
  end

  describe "PUT #update" do
    let(:machine) { Machine.create!(valid_attributes) }

    context "when the user is the author" do
      it "updates the machine and returns success" do
        updated_data = { name: "Updated Machine" }
        put :update, params: { id: machine.id }, body: { machine: updated_data }.to_json, as: :json
        expect(response).to have_http_status(:ok)
        expect(machine.reload.name).to eq("Updated Machine")
      end
    end

    context "when the user is not the author" do
      before { sign_in other_user }

      it "returns forbidden" do
        updated_data = { name: "Updated Machine" }
        put :update, params: { id: machine.id }, body: { machine: updated_data }.to_json, as: :json
        expect(response).to have_http_status(:forbidden)
      end
    end
  end

  describe "DELETE #destroy" do
    let!(:machine) { Machine.create!(valid_attributes) }

    context "when the user is the author" do
      it "destroys the machine and redirects to index" do
        expect do
          delete :destroy, params: { id: machine.id }
        end.to change(Machine, :count).by(-1)
        expect(response).to redirect_to(machines_path)
      end
    end

    context "when the user is not the author" do
      before { sign_in other_user }

      it "does not destroy the machine and redirects to index" do
        expect do
          delete :destroy, params: { id: machine.id }
        end.not_to change(Machine, :count)
        expect(response).to redirect_to(machines_path)
      end
    end
  end
end
