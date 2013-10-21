require 'test_helper'

class UserFriendshipsControllerTest < ActionController::TestCase

    context "#new" do
        context "when not logged in" do
            should "redirect to the login page" do
                get :new
                assert_response :redirect
            end
        end

        context "when logged in" do
            setup do
                sign_in users(:dummy)
            end

            should "get new and return success" do
                get :new
                assert_response :success
            end

            should "should set a flash error if the friend_id params are missing" do
                get :new, {}
                assert_equal "Friend required", flash[:error]
            end

            should "display the friend's name" do
                get :new, friend_id: users(:jim)
                assert_match /#{users(:jim).full_name}/, response.body
            end

            should "assign a new user friendship" do
                get :new, friend_id: users(:jim)
                assert assigns(:user_friendship)
            end

            should "assign a new user friendship to the correct user" do
                get :new, friend_id: users(:jim)
                assert_equal users(:jim), assigns(:user_friendship).friend
            end

            should "assign a new user friendship to the currently logged user" do
                get :new, friend_id: users(:jim)
                assert_equal users(:dummy), assigns(:user_friendship).user
            end

            should "returns a 404 status if no friend is found" do
                get :new, friend_id: 'invalid'
                assert_response :not_found
            end

            should "ask if you really want to friend the user" do
                get :new, friend_id: users(:jim)
                assert_match /Do you really want to friend #{users(:jim).full_name}?/, response.body
            end
        end
    end

    context "#create" do
        context "when not logged in" do
            should "redirect to the login page" do
                get :new
                assert_response :redirect
                assert_redirected_to login_path
            end
        end

        context "when logged in" do
            setup do
                sign_in users(:dummy)
            end

            context "with no friend_id" do
                setup do
                    post :create
                end

                should "set the flash error message" do
                    assert !flash[:error].empty?
                end

                should "redirect to the root path" do
                    assert_redirected_to root_path
                end
            end

            context "with a valid friend_id" do
                setup do
                    post :create, friend_id: users(:mike)
                end

                should "assign a friend object" do
                    assert assigns(:friend)
                end
            end
        end
    end
end
