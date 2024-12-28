require 'rails_helper'

RSpec.describe Users::RegistrationsController, type: :controller do
  describe "GET #new" do
    it "renders the new template" do
      get :new
      expect(response).to have_http_status(:ok)
      expect(response).to render_template(:new)
    end

    it "assigns a new user as resource" do
      get :new
      expect(assigns(:resource)).to be_a_new(User)
    end
  end

  describe "POST #create" do
    let(:valid_attributes) do
      {
        user: {
          email: "test@example.com",
          name: "Test User",
          password: "password123",
          password_confirmation: "password123"
        }
      }
    end

    let(:invalid_attributes) do
      {
        user: {
          email: "",
          name: "",
          password: "123",
          password_confirmation: "1234"
        }
      }
    end

    context "with valid parameters" do
      it "creates a new user" do
        expect do
          post :create, params: valid_attributes
        end.to change(User, :count).by(1)
      end

      it "redirects to the root path after registration" do
        post :create, params: valid_attributes
        expect(response).to redirect_to(root_path)
      end
    end

    context "with invalid parameters" do
      it "does not create a new user" do
        expect do
          post :create, params: invalid_attributes
        end.not_to change(User, :count)
      end

      it "renders the new template again" do
        post :create, params: invalid_attributes
        expect(response).to render_template(:new)
      end

      it "logs errors in the Rails logger" do
        expect(Rails.logger).to receive(:error).with(/Password/).at_least(:once)
        post :create, params: invalid_attributes
      end
    end
  end
end
