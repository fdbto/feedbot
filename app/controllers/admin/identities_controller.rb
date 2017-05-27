
class Admin::IdentitiesController < Admin::BaseController
  before_action :set_user
  before_action :set_user_identity, only: [:show]

  # GET /admin/user/identities
  # GET /admin/user/identities.json
  def index
    @identities = @user.identities.recently_created
  end

  # GET /admin/user/identities/1
  # GET /admin/user/identities/1.json
  def show
  end

  private
  def set_user
    @user = User.find params[:user_id]
  end
  # Use callbacks to share common setup or constraints between actions.
  def set_user_identity
    @identity = @user.identities.find(params[:id])
  end
end
