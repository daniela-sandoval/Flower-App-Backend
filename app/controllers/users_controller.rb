class UsersController < ApplicationController

  def create
    user = User.create(user_params)
    if user.valid?
      render json: {id: user.id, username: user.username, email: user.email, token: encode_token(user)}
    else
      render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def profile
    render json: super_current_user
  end

  def index
    users = User.all
    render json: users
  end

  def send_email
    # need the person(id), the reciever email, and the bouquet ID
    byebug
    sender = User.find_by(params[:id])
    reciever = params[:email_to]
    bouquet = Bouquet.find(params[:bouquet])
    BouquetMailer.email_bouquet(sender, reciever, bouquet).deliver_now
  end

  private

  def user_params
    params.permit(:username, :password, :email)
  end

end
