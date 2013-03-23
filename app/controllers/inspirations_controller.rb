class InspirationsController < ApplicationController
before_filter :admin?, :only => [:index]

  def new
    @inspiration = Inspiration.new
  end

  def create
    @inspiration = current_user.inspirations_created.build(params[:inspiration])
    if current_user.admin?
      @inspiration.status = 0
    else
      @inspiration.status = 1
    end
    if @inspiration.save
      #deliver email to friends if @inspiration.status == 1
      redirect_to :back
    else
      flash[:error] = @inspiration.errors.full_messages
      @admin_inspirations = Inspiration.admin_inspirations
      render :index if current_user.admin?
      render :new if current_user.regular
    end
  end

  def show
    @inspiration = Inspiration.find(params[:id])
  end

  def index
    @admin_inspirations = Inspiration.admin_inspirations
    @inspiration = Inspiration.new
  end

  protected
  def admin?
    redirect_to root_path unless current_user.admin?
  end

end
