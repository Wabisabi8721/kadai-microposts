class UsersController < ApplicationController
  before_action :require_user_logged_in, only: [:index, :show, :followings, :followers, :likes]
  
  def index
    @users = User.all.page(params[:page]) #全ユーザの一覧が欲しいandページネーション（ページを指定してそこだけを取得）
  end

  def show
    @user = User.find(params[:id])
    @microposts = @user.microposts.order('created_at DESC').page(params[:page])
    counts(@user)
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params) #セキュリティの観点からstrong parameterを使用

    if @user.save #ifと保存を同時に行う
      flash[:success] = 'ユーザを登録しました。'
      redirect_to @user #@userのshowルーティングに飛ばす
    else
      flash.now[:danger] = 'ユーザの登録に失敗しました。'
      render :new #@userのインスタンスは残る
    end
  end
  
  def followings
    @user = User.find(params[:id])
    @followings = @user.followings.page(params[:page])
    counts(@user)
  end
  
  def followers
    @user = User.find(params[:id])
    @followers = @user.followers.page(params[:page])
    counts(@user)
  end
  
  def likes
    @user = User.find(params[:id])
    @likes = @user.likes.page(params[:page])
  end
  
  private

  #strong parameter 欲しいデータのみをフィルタリング
  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
end
