Sequel.migration do
  up do
    create_table(:notes) do
      primary_key :id

      String :title
      String :content
      Time :date
      String :liked
      Integer :likes

      foreign_key :user_id
      foreign_key :course_id
    end
  end

  down do
    drop_table(:notes)
  end
end