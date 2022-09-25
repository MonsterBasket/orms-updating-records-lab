require_relative "../config/environment.rb"

class Student
  attr_accessor :id, :name, :grade

  def initialize(name = nil, grade = nil, id = nil)
    @name = name
    @grade = grade
    @id = id
  end

  def self.new_from_db(row)
    self.new row[1], row[2], row[0]
  end

  def self.find_by_name(name)
    sql = "SELECT * FROM students WHERE name = ?"
    new_from_db DB[:conn].execute(sql, name)[0]
    # details = DB[:conn].execute(sql, name)
    # self.new details[0][1], details[0][2], details[0][0]
    # find the student in the database given a name
    # return a new instance of the Student class
  end
  
  def self.create(name, grade)
    new_student = Student.new(name, grade)
    new_student.save
    new_student
  end

  def save
    if self.id
      self.update
    else
      sql = "INSERT INTO students (name, grade) VALUES (?, ?)"
      DB[:conn].execute(sql, name, grade)
      @id = DB[:conn].execute("SELECT last_insert_rowid() FROM students")[0][0]
    end
  end

  def update
    sql = "UPDATE students SET name = ?, grade = ? WHERE id = ?"
    DB[:conn].execute(sql, self.name, self.grade, self.id)
  end
  
  def self.create_table
    sql = <<-SQL
    CREATE TABLE IF NOT EXISTS students (
      id INTEGER PRIMARY KEY,
      name TEXT,
      grade TEXT
    )
    SQL

    DB[:conn].execute(sql)
  end

  def self.drop_table
    sql = "DROP TABLE IF EXISTS students"
    DB[:conn].execute(sql)
  end
end
