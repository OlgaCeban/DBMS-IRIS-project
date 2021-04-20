Class Company.Orders Extends %Persistent
{
    /// Description
    Property Details As %String;

    Property Status As %String;

    Relationship Staff As Company.Staff(%JSONINCLUDE = "none") [Cardinality = one, Inverse = Orders];

    Relationship Clients As Company.Clients(%JSONINCLUDE = "none") [Cardinality = one, Inverse = Orders];

    ClassMethod SaveOrder(OrderObj As Company.Orders) As %Status
    {
        set obj = ##class(Company.Orders).%New()
        
        set obj.Details = OrderObj.Details
        set x = obj.DetailsIsValid(obj.Details)

        set obj.Status = OrderObj.Status
        set x = obj.StatussIsValid(obj.Status)

        set result = obj.%Save()
        Return result
    }

    Method GetOrders(data As %String)
    {
        set data = []
        &sql(
            DECLARE MyCursor CURSOR FOR
            SELECT ID, Details, Status
            INTO :id, :Details, :Status
            FROM Fit.Hero
        )
        &sql(OPEN MyCursor)
    FOR { 
        &sql(FETCH MyCursor)
        if (SQLCODE) quit

        set obj = {"id": (id), "Details": (Details), "Status": (Status) }
        do data.%Push(obj)
        }
        &sql(CLOSE MyCursor)
        quit
    }

}