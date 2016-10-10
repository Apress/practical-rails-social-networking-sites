class EntriesController < ApplicationController
  before_filter :login_required, :except => [:index, :show]
  
  def index
    @user = User.find(params[:user_id])
    @entry_pages = Paginator.new(self, @user.entries_count, 10, params[:page])
    @entries = @user.entries.find(:all, :order => 'created_at DESC',
                                  :limit => @entry_pages.items_per_page,
                                  :offset => @entry_pages.current.offset)
  end

  def show
    @entry = Entry.find_by_id_and_user_id(params[:id], 
                                          params[:user_id], 
                                          :include => [:user, [:comments => :user]])
  end

  def new
    @entry = Entry.new
  end

  def edit
    @entry = @logged_in_user.entries.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to :action => 'index'    
  end

  def create
    @entry = Entry.new(params[:entry])

    if logged_in_user.entries << @entry
      flash[:notice] = 'Entry was successfully created.'
      redirect_to entry_path(:user_id => logged_in_user, 
                             :id => @entry)
    else
      render :action => "new"
    end
  end

  def update
    @entry = @logged_in_user.entries.find(params[:id])

    if @entry.update_attributes(params[:entry])
      flash[:notice] = 'Entry was successfully updated.'
      redirect_to entry_path(logged_in_user.id, @entry)
      #render :action => "edit"
    end
  rescue ActiveRecord::RecordNotFound
    redirect_to :action => 'index'    
  end

  def destroy
    @entry = @logged_in_user.entries.find(params[:id])
    @entry.destroy

    redirect_to entries_path
  rescue ActiveRecord::RecordNotFound
    redirect_to :action => 'index'    
  end
end
