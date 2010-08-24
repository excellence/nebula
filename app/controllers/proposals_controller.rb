class ProposalsController < ApplicationController
  
  before_filter :authenticate_user!, :only => [:new, :edit]
  before_filter :require_primary_character!, :only => [:new, :edit]
  
  def index
    @proposals = Proposal.find(:all, :limit => 10, :order => 'score DESC')
    respond_to do |format|
      format.html
      # TODO: Add JSON, XML formats
    end
  end

  def show
    @proposal = Proposal.find(params[:id])
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
    proposal_exists?
    can_edit?
    @proposal = Proposal.find(params[:id])
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
