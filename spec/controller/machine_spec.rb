require "rails_helper"

RSpec.describe MachinesController, type: :controller do
  let(:user) do
    User.create(
      name: "Test User",
      email: "test_user@example.com",
      password: "password",
      password_confirmation: "password"
    )
  end

  let(:machine) do
    Machine.create(
      name: "Test Machine",
      description: "A machine for testing",
      author: user.id,
      input_counts: 2,
      instructions: [
        "1. x1 = 1",
        "2. if x1 == 0 goto 4 else goto 3",
        "3. x1 = x1 + 1",
        "4. stop"
      ]
    )
  end

  before do
    allow(controller).to receive(:current_user).and_return(user)
  end

  describe "GET #index" do
    it "returns a success response with machines" do
      get :index, format: :json
      expect(response).to have_http_status(:success)
      expect(JSON.parse(response.body)["machines"].length).to eq(Machine.count)
    end
  end

  describe "GET #show_machine" do
    it "returns the machine details" do
      get :show_machine, params: { id: machine.id }, format: :json
      expect(response).to have_http_status(:success)
      json = JSON.parse(response.body)
      expect(json["name"]).to eq(machine.name)
      expect(json["description"]).to eq(machine.description)
    end
  end

  describe "POST #create" do
    it "creates a new Machine with valid parameters" do
      post :create, body: {
        name: "New Machine",
        description: "Another test machine",
        author: user.id,
        input_counts: 3,
        instructions: ["1. x1 = 2", "2. stop"]
      }.to_json, as: :json
      expect(response).to have_http_status(:created)
      json = JSON.parse(response.body)
      expect(json["name"]).to eq("New Machine")
    end

    it "returns unprocessable entity with invalid parameters" do
      post :create, body: { name: "" }.to_json, as: :json
      expect(response).to have_http_status(:unprocessable_entity)
      expect(JSON.parse(response.body)["errors"]).not_to be_empty
    end
  end

  describe "PUT #update" do
    it "updates the machine when the user is the author" do
      put :update, params: { id: machine.id }, body: {
        machine: { name: "Updated Machine" }
      }.to_json, as: :json
      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      expect(json["name"]).to eq("Updated Machine")
    end

    it "returns forbidden when the user is not the author" do
      another_user = User.create(
        name: "Another User",
        email: "another@example.com",
        password: "password",
        password_confirmation: "password"
      )
      allow(controller).to receive(:current_user).and_return(another_user)
      put :update, params: { id: machine.id }, body: {
        machine: { name: "Should Not Update" }
      }.to_json, as: :json
      expect(response).to have_http_status(:forbidden)
    end
  end

  describe "DELETE #destroy" do
    it "destroys the machine when the user is the author" do
      delete :destroy, params: { id: machine.id }
      expect(response).to redirect_to(machines_path)
      expect(Machine.exists?(machine.id)).to be_falsey
    end

    it "does not destroy the machine when the user is not the author" do
      another_user = User.create(
        name: "Another User",
        email: "another@example.com",
        password: "password",
        password_confirmation: "password"
      )
      allow(controller).to receive(:current_user).and_return(another_user)
      delete :destroy, params: { id: machine.id }
      expect(response).to redirect_to(machines_path)
      expect(Machine.exists?(machine.id)).to be_truthy
    end
  end
end
