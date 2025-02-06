# Reproduction of Elixir Partial Select Bug

## Run Reproduction
```shell
elixir test.exs
```

```
: mix test test/repro_select_test.exs:12
The database for ReproSelect.Repo has been dropped

[info] == Running 20250131040705 :"Elixir.ReproSelect.Repo.Migrations.Create tables".change/0 forward

[info] create table parent

[info] create table child

[info] == Migrated 20250131040705 in 0.0s
Running ExUnit with seed: 508772, max_cases: 16
Excluding tags: [:test]
Including tags: [location: {"test/repro_select_test.exs", 12}]


[debug] QUERY OK db=0.5ms
begin []

[debug] QUERY OK source="parent" db=0.4ms
INSERT INTO "parent" ("x") VALUES ($1) RETURNING "id" [1]

[debug] QUERY OK source="child" db=0.4ms
INSERT INTO "child" ("parent_id","x") VALUES ($1,$2) RETURNING "id" [1, 2]

[debug] QUERY OK db=0.1ms
commit []

[debug] QUERY OK source="child" db=0.3ms queue=0.1ms
SELECT c0."x", p1."x" FROM "child" AS c0 INNER JOIN "parent" AS p1 ON p1."id" = c0."parent_id" []


  1) test bug: cannot partial select structs without id (ReproSelectTest)
     test/repro_select_test.exs:12
     ** (Ecto.NoPrimaryKeyValueError) struct `%ReproSelect.Schema.Child{__meta__: #Ecto.Schema.Metadata<:loaded, "child">, id: nil, x: 2, parent_id: nil, parent: #Ecto.Association.NotLoaded<association :parent is not loaded>}` is missing primary key value
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
       test/repro_select_test.exs:27: (test)


Finished in 0.03 seconds (0.00s async, 0.03s sync)
3 tests, 1 failure, 2 excluded
```
