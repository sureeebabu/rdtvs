class Api::V1::SessionsController < Devise::SessionsController
    before_action :sign_in_params, only: :create
    before_action :load_user, only: :create
  
    #login
    def create
        if @user.valid_password?(sign_in_params[:password])
            sign_in "user", @user
            render json: {
                messages: "Sigin Successfully",
                is_success: true,
                user: @user,
                status: :ok
            }
        else
            render json: {
                messages: "Unauthorized",
                is_success: false,
                data: {}
            }, status: :unauthorized
        end
    end

    private
    def user_params
        params.require(:user).permit(:email, :password) 
    end

    def load_user
        @user = User.find_for_database_authentication(email: sign_in_params[:email])
        if @user
            return @user
        else
            json_response "Cannot get User", false, {}, :failure
        end
    end

end
