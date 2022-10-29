# == Schema Information
#
# Table name: bookmarks
#
#  id         :integer          not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  movie_id   :integer
#  user_id    :integer
#
class Bookmark < ApplicationRecord
  validates(:movie_id, { :presence => true })
  validates(:user_id, { :presence => true })

  belongs_to(:movie)   #possible shortcut: add ":required => true" to auto-add the validations for us.
  belongs_to(:user)
end
