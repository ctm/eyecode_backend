class Admin::UsersController < Admin::Base
  # GET /admin_users
  # GET /admin_users.xml
  def index
    @users = User.paginate(:page => params[:page], :order => 'login')

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @users }
    end
  end

  # GET /admin_users/1
  # GET /admin_users/1.xml
  def show
    @user = User.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @user }
    end
  end

  # GET /admin_users/new
  # GET /admin_users/new.xml
  def new
    @user = User.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @user }
    end
  end

  # GET /admin_users/1/edit
  def edit
    @user = User.find(params[:id])
  end

  # POST /admin_users
  # POST /admin_users.xml
  def create
    update_protected_attrs_from_params(:user, :login, :active) do |p|
      @user = User.new(p)
    end

    respond_to do |format|
      if @user.save
        flash[:notice] = 'User was successfully created.'
        format.html { redirect_to([:admin, @user]) }
        format.xml  { render :xml => @user, :status => :created, :location => @user }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /admin_users/1
  # PUT /admin_users/1.xml
  def update
    @user = User.find(params[:id])

    update_protected_attrs_from_params(:user, :login, :active) do |p|
      @user.attributes = p
      @user
    end
    
    respond_to do |format|
      if @user.save
        flash[:notice] = 'User was successfully updated.'
        format.html { redirect_to([:admin, @user]) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /admin_users/1
  # DELETE /admin_users/1.xml
  def destroy
    @user = User.find(params[:id])

    # Special-case code that comes from devctm_template that you will want
    # to remove when you use a more sophisticated authorization system

    if @user.admin?

      # The rationale for not allowing an admin account to be deleted
      # when we have a very simplistic idea of an admin account is to
      # avoid the situation where there no longer is an admin account
      # because of accidental deletion.  This may be acceptable for
      # simple apps and this code is easily deleted once it gets in
      # the way.

      respond_to do |format|
        format.html do
          flash[:notice] = 'An admin account may not be deleted.'
          redirect_to(admin_users_url)
        end
        format.xml do
          @user.errors.add_to_base('An admin account may not be deleted')
          render :xml => @user.errors, :status => :forbidden
        end
      end
    else
      @user.destroy

      respond_to do |format|
        format.html { redirect_to(admin_users_url) }
        format.xml  { head :ok }
      end
    end
  end
end
