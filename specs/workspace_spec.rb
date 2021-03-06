require_relative "test_helper"

describe "Workspace" do
  before do
    VCR.use_cassette("workspace") do
      @workspace = Slack::Workspace.new
    end
  end
  describe "Initialization" do
    it "can be instantiated" do
      VCR.use_cassette("workspace") do
        @workspace = Slack::Workspace.new
        expect(@workspace).must_be_instance_of Slack::Workspace
      end
    end

    it "establishes the base structures when instantiated" do
      [:users, :channels, :selected].each do |prop|
        expect(@workspace).must_respond_to prop
      end

      expect(@workspace.users).must_be_kind_of Array
      expect(@workspace.channels).must_be_kind_of Array
      assert_nil(@workspace.selected) # Changed based on CL feedback... does this make sense?
      # end
    end
  end

  describe "select_user" do
    it "returns the right selected user" do
      input = "sopheary.chiv"
      expect(@workspace.select_user(input).name).must_equal "sopheary.chiv"
    end

    it "stores the right user in the selected variable" do
      before_selecting_user = @workspace.selected
      expect(before_selecting_user).must_be_nil
      @workspace.select_user("sopheary.chiv")
      after_selecting_user = @workspace.selected
      expect(after_selecting_user.name).must_equal "sopheary.chiv"
    end

    it "@selected must be an instance of the user" do
      @workspace.select_user("sopheary.chiv")
      expect(@workspace.selected).must_be_instance_of Slack::User
    end

    it "handles the non-existing user" do
      non_exiting_user = @workspace.select_user("jennifer.chiv")
      expect(non_exiting_user).must_equal false
    end
  end

  describe "select_channel" do
    it "returns the right selected channel" do
      input = "slack-api"
      expect(@workspace.select_channel(input).name).must_equal "slack-api"
    end

    it "stores the right channel in the selected variable" do
      before_selecting_user = @workspace.selected
      expect(before_selecting_user).must_be_nil
      @workspace.select_channel("slack-api")
      after_selecting_user = @workspace.selected
      expect(after_selecting_user.name).must_equal "slack-api"
    end

    it "@selected must be an instance of the channel" do
      @workspace.select_channel("slack-api")
      expect(@workspace.selected).must_be_instance_of Slack::Channel
    end

    it "handles the non-existing channel" do
      non_exiting_user = @workspace.select_channel("my-channel")
      expect(non_exiting_user).must_equal false
    end
  end

  describe "tp_details_options, tp_user_options, tp_channel_options" do
    it "returns user options if selected class is a user" do
      @workspace.select_user("jessica.homet")
      expect(@workspace.tp_details_options).must_equal [:name, :real_name, :slack_id]
    end

    it "returns channel options if selected class is a user" do
      @workspace.select_channel("slack-api")
      expect(@workspace.tp_details_options).must_equal [:name, :topic, :member_count, :slack_id]
    end
  end

  describe "send_message" do
    it "sends a valid message" do
      VCR.use_cassette("slack_message") do
        @workspace.select_user("sopheary.chiv")
        expect(@workspace.send_message("test")).must_equal true
      end
    end
  end
end
