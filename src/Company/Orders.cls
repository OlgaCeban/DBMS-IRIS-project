Class Company.Orders Extends (%Persistent, %Populate)
{

/// Description
Property Details As %String;

Property Status As %String;

Relationship Client As Company.Clients [ Cardinality = one, Inverse = Orders ];

Relationship Staff As Company.Staff [ Cardinality = one, Inverse = Orders ];

Relationship Review As Company.Review [ Cardinality = one, Inverse = Orders ];

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
            FROM Company.Orders
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

Storage Default
{
<Data name="OrdersDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Details</Value>
</Value>
<Value name="3">
<Value>Status</Value>
</Value>
<Value name="4">
<Value>Client</Value>
</Value>
<Value name="5">
<Value>Staff</Value>
</Value>
<Value name="6">
<Value>Review</Value>
</Value>
</Data>
<DataLocation>^Company.OrdersD</DataLocation>
<DefaultData>OrdersDefaultData</DefaultData>
<IdLocation>^Company.OrdersD</IdLocation>
<IndexLocation>^Company.OrdersI</IndexLocation>
<StreamLocation>^Company.OrdersS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
