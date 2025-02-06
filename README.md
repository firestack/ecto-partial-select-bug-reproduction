# Reproduction of Elixir Partial Select Bug

## Run Reproduction
```sh
elixir test.exs
```

### Bug: Partial Select with Limit 1
```elixir
  * test bug: cannot partial select structs without id: single element [L#137]
16:34:44.895 [debug] QUERY OK db=0.7ms
begin []

16:34:44.899 [debug] QUERY OK source="my_schema" db=0.3ms
INSERT INTO "my_schema" ("property") VALUES ($1) RETURNING "id" [58]

16:34:44.900 [debug] QUERY OK source="single_association" db=0.4ms
INSERT INTO "single_association" ("my_schema_id","x") VALUES ($1,$2) RETURNING "id" [464, 17]

16:34:44.900 [debug] QUERY OK db=0.1ms
commit []

16:34:44.901 [debug] QUERY OK source="single_association" db=0.2ms queue=0.1ms
SELECT s0."x", m1."property" FROM "single_association" AS s0 INNER JOIN "my_schema" AS m1 ON m1."id" = s0."my_schema_id" []

  * test bug: cannot partial select structs without id: single element (13.4ms) [L#137]

  test bug: cannot partial select structs without id: single element (Tests)
     test.exs:137
     ** (Ecto.NoPrimaryKeyValueError) struct
     `%Test.Schemas.SingleAssociation{
         __meta__: #Ecto.Schema.Metadata<:loaded, "single_association">,
         id: nil,
         x: 17,
         my_schema_id: nil,
         my_schema: #Ecto.Association.NotLoaded<association :my_schema is not loaded>
     }`
     is missing primary key value
     code: |> Repo.one!()
     stacktrace:
       (ecto 3.12.5) lib/ecto/repo/assoc.ex:40: anonymous fn/2 in Ecto.Repo.Assoc.merge/3
       (elixir 1.17.3) lib/enum.ex:1703: Enum."-map/2-lists^map/1-1-"/2
       (ecto 3.12.5) lib/ecto/repo/assoc.ex:38: Ecto.Repo.Assoc.merge/3
       (ecto 3.12.5) lib/ecto/repo/assoc.ex:23: anonymous fn/3 in Ecto.Repo.Assoc.query/4
       (elixir 1.17.3) lib/enum.ex:2531: Enum."-reduce/3-lists^foldl/2-0-"/3
       (ecto 3.12.5) lib/ecto/repo/assoc.ex:22: Ecto.Repo.Assoc.query/4
       (ecto 3.12.5) lib/ecto/repo/queryable.ex:237: Ecto.Repo.Queryable.execute/4
       (ecto 3.12.5) lib/ecto/repo/queryable.ex:19: Ecto.Repo.Queryable.all/3
       (ecto 3.12.5) lib/ecto/repo/queryable.ex:162: Ecto.Repo.Queryable.one!/3
       test.exs:159: (test)
```

### Bug: Bug Partial Select with no Limit
```elixir
  * test bug: cannot partial select structs without id: list [L#162]
16:33:54.902 [debug] QUERY OK db=0.7ms
begin []

16:33:54.907 [debug] QUERY OK source="my_schema" db=0.4ms
INSERT INTO "my_schema" ("property") VALUES ($1) RETURNING "id" [9]

16:33:54.907 [debug] QUERY OK source="single_association" db=0.5ms
INSERT INTO "single_association" ("my_schema_id","x") VALUES ($1,$2) RETURNING "id" [462, 85]

16:33:54.907 [debug] QUERY OK db=0.1ms
commit []

16:33:54.908 [debug] QUERY OK db=0.0ms
begin []

16:33:54.908 [debug] QUERY OK source="my_schema" db=0.1ms
INSERT INTO "my_schema" ("property") VALUES ($1) RETURNING "id" [99]

16:33:54.908 [debug] QUERY OK source="single_association" db=0.1ms
INSERT INTO "single_association" ("my_schema_id","x") VALUES ($1,$2) RETURNING "id" [463, 35]

16:33:54.908 [debug] QUERY OK db=0.0ms
commit []

16:33:54.910 [debug] QUERY OK source="single_association" db=0.3ms queue=0.1ms
SELECT s0."x", m1."property" FROM "single_association" AS s0 INNER JOIN "my_schema" AS m1 ON m1."id" = s0."my_schema_id" []

  * test bug: cannot partial select structs without id: list (15.0ms) [L#162]

  test bug: cannot partial select structs without id: list (Tests)
     test.exs:162
     ** (Ecto.NoPrimaryKeyValueError) struct
     `%Test.Schemas.SingleAssociation{
         __meta__: #Ecto.Schema.Metadata<:loaded, "single_association">,
         id: nil,
         x: 85,
         my_schema_id: nil,
         my_schema: #Ecto.Association.NotLoaded<association :my_schema is not loaded>
     }`
     is missing primary key value
     code: |> Repo.all()
     stacktrace:
       (ecto 3.12.5) lib/ecto/repo/assoc.ex:40: anonymous fn/2 in Ecto.Repo.Assoc.merge/3
       (elixir 1.17.3) lib/enum.ex:1703: Enum."-map/2-lists^map/1-1-"/2
       (ecto 3.12.5) lib/ecto/repo/assoc.ex:38: Ecto.Repo.Assoc.merge/3
       (ecto 3.12.5) lib/ecto/repo/assoc.ex:23: anonymous fn/3 in Ecto.Repo.Assoc.query/4
       (elixir 1.17.3) lib/enum.ex:2531: Enum."-reduce/3-lists^foldl/2-0-"/3
       (ecto 3.12.5) lib/ecto/repo/assoc.ex:22: Ecto.Repo.Assoc.query/4
       (ecto 3.12.5) lib/ecto/repo/queryable.ex:237: Ecto.Repo.Queryable.execute/4
       (ecto 3.12.5) lib/ecto/repo/queryable.ex:19: Ecto.Repo.Queryable.all/3
       test.exs:199: (test)
```
