create role anon;
create extension if not exists "uuid-ossp";
create extension if not exists pg_graphql cascade;


grant usage on schema public to postgres, anon;
alter default privileges in schema public grant all on tables to postgres, anon;
alter default privileges in schema public grant all on functions to postgres, anon;
alter default privileges in schema public grant all on sequences to postgres, anon;

grant usage on schema graphql to postgres, anon;
grant all on function graphql.resolve to postgres, anon;

alter default privileges in schema graphql grant all on tables to postgres, anon;
alter default privileges in schema graphql grant all on functions to postgres, anon;
alter default privileges in schema graphql grant all on sequences to postgres, anon;


-- GraphQL Entrypoint
create function graphql("operationName" text default null, query text default null, variables jsonb default null)
    returns jsonb
    language sql
as $$
    select graphql.resolve(query, coalesce(variables, '{}'));
$$;


create table mfe(
    id serial primary key,
    created_at timestamp not null,
    name varchar(255) not null,
    updated_at timestamp not null,
    url_es varchar(2000) not null,
    url_umd varchar(2000) not null,
    version varchar(100) not null unique
);


insert into public.mfe(
  created_at,
  name,
  updated_at,
  url_es,
  url_umd,
  version
)
values
    (now(), 'demo', now(), '//host/abc.js', '//host/abc.es.js', '0.0.1');
