# == Schema Information
#
# Table name: characters
#
#  id         :integer          not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  actor_id   :integer
#  movie_id   :integer
#
class Character < ApplicationRecord
  validates(:name, {:presence => true, :uniqueness => { :scope => [:movie_id] }})
  validates(:movie_id, { :presence => true })
  validates(:actor_id, { :presence => true })

  belongs_to(:movie)
  belongs_to(:actor)
end
