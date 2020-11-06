CREATE OR REPLACE FUNCTION public.getTableNameByIdColumn(_id numeric)
    RETURNS SETOF text AS
$func$
DECLARE
    _tbl text;
BEGIN
    FOR _tbl IN
        SELECT quote_ident(table_schema) || '.' || quote_ident(table_name)
        FROM   information_schema.columns
        WHERE  table_schema LIKE 'public'
          AND    column_name LIKE 'id'
        LOOP
            RETURN QUERY EXECUTE format (
         $$
         SELECT %1$L::text
         FROM   %1$s
         WHERE id::text = $1::text
         --bad, you should compare numeric but for me it's unacceptable
         $$, _tbl
                )
                USING _id;
        END LOOP;
    RETURN;
END
$func$  LANGUAGE plpgsql;
