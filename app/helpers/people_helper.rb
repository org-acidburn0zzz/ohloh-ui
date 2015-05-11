module PeopleHelper
  def people_contribution_list_for(person)
    if person.account.nil?
      people_contribution_list_for_no_account(person)
    else
      people_contribution_list_for_account(person.account)
    end
  end

  def people_position(person)
    return I18n.t('kudos.not_yet_ranked') unless person.kudo_score
    person.kudo_position
  end

  private

  def people_contribution_list_for_no_account(person)
    contributions = person.contributions
    contributions.empty? ? '' : people_contributes_to_sentence(contributions.map(&:project))
  end

  def people_contribution_list_for_account(account)
    projects = account.position_core.with_projects.to_a
    projects.empty? ? '' : people_contributes_to_sentence(projects.map(&:project))
  end

  def people_contributes_to_sentence(projects)
    sentence = projects.map { |p| link_to(sanitize(p.name), project_path(p)) }.to_sentence
    I18n.t('people.contributes_to', sentence: sentence)
  end
end