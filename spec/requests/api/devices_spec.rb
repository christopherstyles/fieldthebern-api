require 'rails_helper'

describe "Devices API" do

  describe "POST /devices" do

    let(:token) { authenticate(email: "test-user@mail.com", password: "password") }
    before do
      @user = create(:user, email: "test-user@mail.com", password: "password")
    end

    context "when the device doesn't exist" do
      it "should create a new device for a user" do

        authenticated_post "devices", {
          data: {
            attributes: {
              token: "123456",
              enabled: true,
              platform: "Android"
            }
          }
        }, token

        expect(json.data.id).not_to be_blank
        expect(json.data.attributes.token).to eq "123456"
        expect(json.data.attributes.platform).to eq "Android"
        expect(json.data.attributes.enabled).to be true
        expect(json.data.relationships.user.data.id).to eq @user.id.to_s
      end
    end

    context "when the device already exists" do
      it "should update the existing device" do
        create(:device, id: 5, token: 123456, user_id: @user.id)

        authenticated_post "devices", {
          data: {
            attributes: {
              token: "123456",
              enabled: true,
              platform: "Android"
            }
          }
        }, token

        expect(Device.count).to eq 1
        expect(json.data.id).to eq "5"
        expect(json.data.attributes.token).to eq "123456"
        expect(json.data.attributes.platform).to eq "Android"
        expect(json.data.attributes.enabled).to be true
        expect(json.data.relationships.user.data.id).to eq @user.id.to_s
      end
    end
  end
end
