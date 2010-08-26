class ProposalsController < ApplicationController
  
  before_filter :authenticate_user!, :only => [:new, :edit, :update, :create, :vote]
  before_filter :require_primary_character!, :only => [:new, :edit, :update, :create, :vote]
  
  def index
    @popular_proposals = Proposal.find(:all, :limit => 10, :order => 'score DESC', :include => [:character, :tags, :state])
    @recent_proposals = Proposal.find(:all, :limit => 5, :order => 'created_at DESC', :include => [:character, :tags, :state])
    respond_to do |format|
      format.html
      # TODO: Add JSON, XML formats
    end
  end
  def recent
    @proposals = Proposal.find(:all, :limit => 25, :order => 'created_at DESC')
  end
  def my
    @proposals = Proposal.find(:all, :conditions => {:user_id => current_user.id}, :order => 'score DESC')
  end

  def show
    @proposal = Proposal.find(params[:id], :include=>[:tags, :state, :state_changes, :character])
    @user_votes = current_user.votes_on_proposal(@proposal.id)
    respond_to do |format|
      format.html
      # TODO: Add JSON, XML formats
    end
  end

  def new
    @proposal = Proposal.new
    @proposal.user_id = current_user.id
    @proposal.character_id = current_user.character_id
  end
  
  def preview
    render :text => ::RedCloth.new(params['data']).to_html
  end
  
  def create
    @proposal = Proposal.new(params[:proposal])
    @proposal.user_id = current_user.id
    @proposal.character_id = current_user.character_id
    if @proposal.save
      flash[:info] = "Your proposal has been submitted and is now open for discussion in the community"
      redirect_to proposal_path(@proposal)
    else
      flash[:error] = "Your proposal could not be submitted. Please check the errors listed below."
      render :action => :new
    end
  end

  def edit
    @proposal = current_user.proposals.find(params[:id])
    proposal_exists?
    can_edit?
  end
  
  def update
    @proposal = Proposal.find(params[:id])
    proposal_exists?
    can_edit?
    @proposal.update_attributes(params[:proposal])
    if @proposal.save
      flash[:info] = "Your proposal has been updated"
      redirect_to proposal_path(@proposal)
    else
      flash[:error] = "Your proposal could not be updated. Please check the errors listed below."
      render :action => :new
    end
  end
  
  def vote
    @proposal = Proposal.find(params[:id])
    proposal_exists?
    v = true
    current_user.validated_accounts.each do |a|
      if !@proposal.vote!(a.id, params[:score].to_i)
        v = false
      end
    end
    if v
      if params[:score].to_i == 0
        flash[:info] = "Your #{current_user.accounts.length > 1 ? 'votes have' : 'vote has'} been removed from this proposal successfully"
      else
        flash[:info] = "Your #{current_user.accounts.length > 1 ? 'votes have' : 'vote has'} been cast on this proposal successfully"
      end
      if current_user.invalidated_accounts.length > 0
        if current_user.invalidated_accounts.length > 1
          flash[:error] = "Several of your accounts have not been validated, and as such their votes have not been cast"
        else
          flash[:error] = "One of your accounts has not been validated, and as such that account's vote has not been cast"
        end
      end
    else
      flash[:error] = "One or more of your votes could not be registered. This may be due to an account that needs validation."
    end
    redirect_to proposal_path(@proposal)
  end
  
  private
  # Helper, checks that @proposal is set, if not redirects back to proposals home
  def proposal_exists?
    if !@proposal
      flash[:error] = "Specified proposal was not found"
      redirect_to '/proposals'
      return
    end
  end
  # Helper, checks that the proposal in @proposal can be edited by the current user, if not redirects back to proposals home
  def can_edit?
    if !@proposal.can_edit?(current_user)
      flash[:error] = "Specified proposal cannot be edited"
      redirect_to '/proposals'
      return
    end
  end

end
