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
            this._buildFromObject(criteria)
        } else {
            this._buildFromPk(criteria)
        }

    }

    _buildFromObject(attributes)
    {
        for name, value in attributes {
            this.%name% := value
        }
    }

    _buildFromPk(searchPk)
    {
        local results := ""

        query := "SELECT * FROM " this.tableName " WHERE " this.pk " = '" searchPk "'"
        results := DBA.ActiveRecord.connection.query(query)

        firstRow := results.row(1)
        this._buildFromObject(firstRow)
    }

    build(where := "", orderBy := "", limit := -1, page := -1)
    {
        return DBA.RecordSet.build(this, where, orderBy, limit, page)
    }

}