Sequel.migration do
  up do
    create_table(:users) do
      primary_key :id

      String :username
      String :password
      String :picurl
      String :aboutme

    end
  end

  down do
    drop_table(:users)
  end
end