; DBA.RecordSet
class RecordSet
{
    records := []

    __New(records)
    {
        this.records := records
    }

    buildWith(classObjOrTable, fields, where := "", orderBy := "", limit := "", page := "")
    {
        tableName := classObjOrTable
        if (IsObject(classObjOrTable)) {
            tableName := classObj.tableName
        }

        results := DBA.QueryBuilder
            .from(tableName)
            .select(fields)
            .where(where)
            .orderBy(orderBy)
            .limit(limit)
            .page(page)
            .run()

        records := []

        for index, row in results.data() {
            records.push(new DBA.ActiveRecord(row))
        }

        return records
    }

    build(classObjOrTable, where := "", orderBy := "", limit := "", page := "")
    {
        return this.buildWith(classObjOrTable, "*", where, orderBy, limit, page)
    }
}