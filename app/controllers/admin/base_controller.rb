class Admin::BaseController < ApplicationController
  before_action :verify_admin
end
