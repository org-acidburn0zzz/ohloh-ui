class NilAnalysis < NullObject
  attr_reader :main_language

  def twelve_month_summary
    NilAnalysisSummary.new
  end

  def previous_twelve_month_summary
    NilAnalysisSummary.new
  end

  def name_fact_for(_name_id)
    false
  end

  def activity_level
    :na
  end
end