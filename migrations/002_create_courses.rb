Sequel.migration do
  up do
    create_table(:courses) do
      primary_key :id

      String :name
      String :teacher
      String :joined

    end
  end

  down do
    drop_table(:courses)
  end
end