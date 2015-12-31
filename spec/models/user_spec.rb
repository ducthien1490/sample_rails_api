require 'spec_helper'

describe User do
  before do
    @user = FactoryGirl.build :user
  end

  subject { @user }

  it { should respond_to :email }
  it { should respond_to :password }
  it { should respond_to :password_confirmation }

  it { should be_valid }
end
