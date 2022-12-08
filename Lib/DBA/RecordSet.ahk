; DBA.RecordSet
class RecordSet
{
    build(classObj, where := "", orderBy := "", limit := -1, page := -1)
    {
        local query := "SELECT"
        local results := ""

        ; Limit and page, if those variables are specified
        if (limit != -1) {
            query .= " FIRST " limit

            if (page != -1) {
                query .= " SKIP " (limit * (page - 1))
            }
        }

        ; Get all columns from the specified table name
        query .= "* FROM " classObj.tableName

        ; Add our where statement, if specified
        if (where != "") {
            query .= " WHERE " where
        }

        ; Add our order by statement, if specified
        if(orderBy != "") {
            query .= " ORDER BY " orderBy
        }

        results := DBA.ActiveRecord.connection.query(query)

        records := []

        for index, row in results {
            records.push(new DBA.ActiveRecord(row))
        }

        return records
    }
}