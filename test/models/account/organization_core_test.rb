require_relative '../../test_helper'

class Account::OrganizationCoreTest < ActiveSupport::TestCase
  def setup
    @account = accounts(:admin)
    @account_org = Account::OrganizationCore.new(@account.id)
  end

  it 'organizations affiliated with projects I contribute to' do
    orgs_for_my_positions = @account_org.orgs_for_my_positions

    orgs_for_my_positions.size.must_equal 1
    orgs_for_my_positions.first.class.must_equal Organization
    orgs_for_my_positions.first.name.must_equal 'Linux Foundations'
  end

  it 'affiliations for the projects I contributed to' do
    project = @account.positions.first
    project.affiliation = Organization.where { id.eq(1) }.first
    project.save

    affiliations_for_my_positions = @account_org.affiliations_for_my_positions

    affiliations_for_my_positions.size.must_equal 1
    affiliations_for_my_positions.first.class.must_equal Organization
    affiliations_for_my_positions.first.name.must_equal 'Linux Foundations'
  end

  it 'contributions_to_org_portfolio' do
    analysis = analyses(:linux)
    projects(:linux).update_attributes! best_analysis_id: analysis.id
    @account.update_column :organization_id, organizations(:linux).id
    @account.reload

    @account_org.contributions_to_org_portfolio.must_equal 1
    @account_org.contributions_outside_org.must_equal 0
  end

  it 'contributions_outside_org' do
    analysis = analyses(:linux)
    projects(:linux).update_attributes! best_analysis_id: analysis.id
    account = accounts(:user)
    account.update_column(:organization_id, organizations(:google).id)
    account_org = Account::OrganizationCore.new(account.id)
    account.reload

    account_org.contributions_outside_org.must_equal 1
  end
end