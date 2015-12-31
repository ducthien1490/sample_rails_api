require 'spec_helper'

describe Api::V1::UsersController do
  before(:each) { request.headers['Accept'] = "application/vnd.marketplace.v1" }

  describe 'GET #show' do
    before(:each) do
      @user = FactoryGirl.create :user
      get :show, id: @user.id, format: :json
    end

    it "returns the information about a reporter on a hash" do
      user_response = JSON.parse(response.body, symbolize_names: true)
      expect(user_response[:email]).to eql @user.email
    end

    it { should respond_with 200 }
  end

  describe 'POST #create' do
    before(:each) do
      @invalid_user_attributes = {
        password: '123456789',
        password_confirmation: '123456789'
      }
      post :create, { user: @invalid_user_attributes }, format: :json
    end

    it "renders an errors json" do
      user_response = JSON.parse(response.body, symbolize_names: true)
      expect(user_response).to have_key(:errors)
    end

    it "render the json errors on why the user could not be create" do
      user_response = JSON.parse(response.body, symbolize_names: true)
      expect(user_response[:errors][:email]).to include "can't be blank"
    end

    it { should respond_with 422 }
  end

  describe 'PUT/PATCH #update' do
    context "successufl update" do
      before(:each) do
        @user = FactoryGirl.create :user
        patch :update, {id: @user.id, user: { email: "test1@example.com" } },
          format: :json
      end

      it "render the json representation for the updated user" do
        user_response = JSON.parse(response.body, symbolize_names: true)
        expect(user_response[:email]).to eql "test1@example.com"
      end

      it { should respond_with 200 }
    end

    context "not created" do
      before(:each) do
        @user = FactoryGirl.create :user
        patch :update, { id: @user.id , user: { email: "bademail.com" } },
          format: :json
      end

      it "renders an errors json" do
        user_response = JSON.parse(response.body, symbolize_names: true)
        expect(user_response).to have_key(:errors)
      end

      it "renders the json errors why the user cannot be created" do
        user_response = JSON.parse(response.body, symbolize_names: true)
        expect(user_response[:errors][:email]).to include "is invalid"
      end

      it { should respond_with 422 }
    end
  end

  describe 'DELETE #destroy' do
    before(:each) do
      @user = FactoryGirl.create :user
      delete :destroy, { id: @user.id }, format: :json
    end

    it { should respond_with 204 }
  end
end
