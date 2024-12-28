RSpec.describe Users::RegistrationsController, type: :controller do
  before do
    @request.env["devise.mapping"] = Devise.mappings[:user]
  end

  let(:valid_attributes) do
    {
      email: "test@example.com",
      name: "Test User",
      password: "password",
      password_confirmation: "password"
    }
  end

  let(:invalid_attributes) do
    {
      email: "invalid",
      name: "",
      password: "123",
      password_confirmation: "1234"
    }
  end

  describe "GET #new" do
    it "renders the new template" do
      get :new
      expect(response).to render_template(:new)
    end

    it "assigns a new user as resource" do
      get :new
      expect(assigns(:resource)).to be_a_new(User)
    end
  end

  describe "POST #create" do
    context "with valid parameters" do
      it "creates a new user" do
        expect do
          post :create, params: { user: valid_attributes }
        end.to change(User, :count).by(1)
      end

      it "redirects to the root path" do
        post :create, params: { user: valid_attributes }
        expect(response).to redirect_to(root_path)
      end
    end

    context "with invalid parameters" do
      it "does not create a new user" do
        expect do
          post :create, params: { user: invalid_attributes }
        end.not_to change(User, :count)
      end

      it "renders the new template again" do
        post :create, params: { user: invalid_attributes }
        expect(response).to render_template(:new)
      end
    end
  end
end
