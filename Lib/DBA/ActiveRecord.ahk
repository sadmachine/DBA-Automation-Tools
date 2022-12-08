; DBA.ActiveRecord
class ActiveRecord
{

    _connection := ""
    _pk := ""
    _tableName := ""

    connection[]
    {
        get
        {
            return this._connection
        }
        set
        {
            this._connection := value
            return this._connection
        }
    }

    pk[]
    {
        get
        {
            return this._pk
        }
        set
        {
            this._pk := value
            return this._pk
        }
    }

    tableName[]
    {
        get
        {
            if (this.__tableName == "") {
                return this.__Class
            }
            return this._tableName
        }
        set
        {
            this._tableName := value
            return this._tableName
        }
    }

    __New(criteria)
    {
        if (IsObject(criteria)) {
            this._loadFromCriteria(criteria)
        } else {
            this._loadFromPk(criteria)
        }
    }

    _loadFromCriteria(criteria)
    {
        DBA.ActiveRecord.connection
    }

    _loadFromPk(pk)
    {

    }

    build(where := "", orderBy := "", limit := -1, page := -1)
    {
        local query := "SELECT"

        ; Limit and page, if those variables are specified
        if (limit != -1) {
            query .= " FIRST " limit

            if (page != -1) {
                query .= " SKIP " (limit * (page - 1))
            }
        }

        ; Get all columns from the specified table name
        query .= "* FROM " this.tableName

        ; Add our where statement, if specified
        if (where != "") {
            query .= " WHERE " where
        }

        ; Add our order by statement, if specified
        if(orderBy != "") {
            query .= " ORDER BY " orderBy
        }

        DBA.ActiveRecord.connection.query(query)
    }

}