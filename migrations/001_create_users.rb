Sequel.migration do
  up do
    create_table(:users) do
      primary_key :id

      String :username
      String :password
      String :picurl
      String :coursejoin

    end
  end

  down do
    drop_table(:users)
  end
end