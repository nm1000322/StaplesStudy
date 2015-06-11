class User < Sequel::Model
  many_to_many :courses
  one_to_many :notes
  one_to_many :comment
  #.course array of all course
  #.add_course(@course)
  #.remove_course(@course)
  def in_course(course)
    self.courses_dataset.where(:course_id => course.id)
  end
end
class Course < Sequel::Model
  many_to_many :users
  one_to_many :notes
end
class Note < Sequel::Model
  many_to_one :courses
  many_to_one :users
  one_to_many :comments
end
class Comment < Sequel::Model
  many_to_one :users
  many_to_one :notes
end
