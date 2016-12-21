require 'test_helper'

class ManagementControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get management_index_url
    assert_response :success
  end

  test "should get import" do
    get management_import_url
    assert_response :success
  end

  test "should get backup" do
    get management_backup_url
    assert_response :success
  end

  test "should get restore" do
    get management_restore_url
    assert_response :success
  end

end
