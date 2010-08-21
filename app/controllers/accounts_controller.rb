class AccountsController < ApplicationController
  before_filter :authenticate_user!
  def index
  end

  def new
    @account = Account.new
  end
  
  def create
    @account = Account.new(params[:account])
    @account.user_id = current_user.id
    if @account.save
      # Queue the update for this key, specifying higher priority queue
      @account.async_update!(true)
      flash[:info] = "Your EVE Online account has been added and is pending validation with the EVE Online API"
      redirect_to account_path(@account)
    else
      flash[:error] = "Your EVE Online account could not be added. Please see the errors listed below for details."
      render :action => :new
    end
  end

  def edit
    @account = current_user.accounts.find_by_id(params[:id])
    if !@account
      flash[:error] = "Specified account was not found"
      redirect_to '/accounts'
      return
    end
  end
  
  def update
    @account = current_user.accounts.find_by_id(params[:id])
    @account.api_key = params[:account][:api_key]
    if @account.save
      # Queue the update for this key, specifying higher priority queue
      @account.async_update!(true)
      flash[:info] = "Your EVE Online account has been added and is pending validation with the EVE Online API"
      redirect_to account_path(@account)
    else
      flash[:error] = "Your EVE Online account could not be added. Please see the errors listed below for details."
      render :action => :new
    end
  end
  
  def show
    @account = current_user.accounts.find_by_id(params[:id])
    if !@account
      flash[:error] = "Specified account was not found"
      redirect_to '/accounts'
      return
    end
  end

  
  def destroy
    @account = current_user.accounts.find_by_id(params[:id])
    if @account.destroy
      flash[:info] = "The selected EVE Online account details have been deleted from this account."
      redirect_to accounts_path
    else
      flash[:error] = "The selected EVE Online account details could not be deleted from this account."
      redirect_to accounts_path
    end
    
  end

end
