require "test_helper"

class MicropostTest < ActiveSupport::TestCase
  def setup
    @user = users(:michael)
    @micropost = @user.microposts.build(content: "Lorem ipsum")
  end

  test "should be valid" do
    assert @micropost.valid?
  end

  test "user id should be present" do
    # debugger
    @micropost.user_id = nil
    assert_not @micropost.valid?
  end

  test "content should be present " do
    @micropost.content = " "
    assert_not @micropost.valid?
  end

  test "content should be at most 140 characters" do
    @micropost.content = "a" * 141
    assert_not @micropost.valid?
  end

  test "order should be most recent first" do
    assert_equal Micropost.first, microposts(:most_recent)
  end

  test "associated microposts should be destroyed" do
    @other_user = users(:mallory)
    @other_user.microposts.create!(content: "Lorem ipsum")
    # debugger
    assert_difference "Micropost.count", -1 do
      @other_user.destroy
    end
  end
end
