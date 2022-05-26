# Model to represent a score played by a golfer
# - total_score: total number of hits to finish all 18 holes
# - played_at: date when the score was played
class Score < ApplicationRecord
  belongs_to :user

  validates :number_of_holes, inclusion: { in: [9, 18] }
  validate :score_range
  validate :future_score

  def serialize
    {
      id: id,
      user_id: user_id,
      user_name: user.name,
      total_score: total_score,
      played_at: played_at,
      number_of_holes: number_of_holes,
    }
  end

  private

  def future_score
    errors.add(:played_at, 'must not be in the future') if played_at > Time.zone.today
  end

  def score_range
    range = ''
    range = '27..90' if number_of_holes == 9
    range = '54..180' if number_of_holes == 18
    errors.add(:total_score, "is not in #{range} range") if
      (number_of_holes == 9 && !total_score.between?(27, 90)) ||
      (number_of_holes == 18 && !total_score.between?(54, 180))
  end
end
