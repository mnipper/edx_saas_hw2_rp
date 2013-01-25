class Movie < ActiveRecord::Base
  def self.ratings
    ratings = []
    Movie.select("DISTINCT rating").each { |m| ratings << m.rating }
    ratings.sort
  end
end
