# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#   
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Major.create(:name => 'Daley', :city => cities.first)

# Create our states.
# States have a name, description, and a few flags - can_vote, can_alter and show_in_lists. These are by default all true if not otherwise specified.
# show_in_lists refers to summary lists like 'popular issues' etc - all items will always be accessible in _a_ list somewhere.

State.create({ :name => 'New', :description => 'Proposal is less than 7 days old' })
State.create({ :name => 'Open', :description => 'Proposal is more than 7 days old, but has not been raised or voted on by the CSM' })
State.create({ :name => 'Locked', :description => 'Proposal has been locked by an administrator or CSM member', :can_vote => false, :can_alter => false, :show_in_lists => false })
State.create({ :name => 'Withdrawn', :description => 'Proposal has been withdrawn by the proposer', :can_vote => false, :can_alter => false, :show_in_lists => false })
State.create({ :name => 'Dormant', :description => 'Proposal has not been voted on or discussed for 30 days and has been locked', :can_vote => false, :can_alter => false, :show_in_lists => false })
State.create({ :name => 'Raised', :description => 'Selected by a CSM member for voting upon at a future meeting', :can_alter => false })
State.create({ :name => 'Failed', :description => 'Voted on and failed by the CSM', :can_alter => false, :can_vote => false, :show_in_lists => false })
State.create({ :name => 'Passed', :description => 'Voted on and passed by the CSM', :can_alter => false })
State.create({ :name => 'Submitted', :description => 'Submitted to CCP for consideration', :can_alter => false })
State.create({ :name => 'Denied', :description => 'Denied by CCP', :can_vote => false, :can_alter => false, :show_in_lists => false })
State.create({ :name => 'Backlogged', :description => 'Approved by CCP and placed in the CCP backlog', :can_vote => false, :can_alter => false, :show_in_lists => false })
State.create({ :name => 'Maybe', :description => 'Given a "Maybe" answer by CCP, in need of further internal discussion', :can_vote => false, :can_alter => false, :show_in_lists => false })
State.create({ :name => 'Duplicate', :description => 'Proposal already exists, this is a duplicate of another proposal', :can_vote => false, :can_alter => false, :show_in_lists => false })
State.create({ :name => 'Implemented', :description => 'Proposal has been implemented in EVE Online', :can_vote => false, :can_alter => false, :show_in_lists => false })
