Class Company.Clients Extends (%Persistent, %Populate)
{

Property FIO As %String [ Required ];

Property Email As %String;

Property Phone As %String;

Property DOB As %Date;

Relationship Orders As Company.Orders [ Cardinality = many, Inverse = Client ];

ClassMethod CreateClient(FIO As %String = "", Email As %String = "", Phone As %String = "", DOB As %Date = 0) As Company.Clients
{
        set client = ..%New()
        set client.FIO = FIO
        set client.Email = Email
        set client.Phone = Phone
        set client.DOB = DOB
        set st = client.%Save()
        return client
}

ClassMethod SaveClient(clientObj As Company.Clients) As %Status
{
        set obj = ##class(Company.Clients).%New()

        set obj.FIO = clientObj.FIO
        set x = obj.FIOIsValid(obj.FIO)

        set obj.Email = clientObj.Email
        set x = obj.EmailIsValid(obj.Email)

        set obj.Phone = clientObj.Phone
        set x = obj.PhoneIsValid(obj.Phone)

        set obj.DOB = clientObj.DOB
        set x = obj.DOBIsValid(obj.DOB)

        set result = obj.%Save()
        return result
}

ClassMethod GetClient(ID As %Integer) As Company.Clients
{
        set obj = ##class(Company.Clients).%OpenId(ID)
        Return obj
}

ClassMethod DeleteClient(ID As %Integer) As %Status
{
        set result = ##class(Company.Clients).%DeleteId(ID)
        Return result
}

Method GetClients(data) As %String
{
        set data = []
        &sql(
            DECLARE MyCursor CURSOR FOR
            SELECT ID, DOB, FIO
            INTO :ID, :DOB, :FIO
            FROM Company.Clients
        )
        &sql(OPEN MyCursor)
        
    FOR { 
        &sql(FETCH MyCursor)
        if (SQLCODE) quit

        set obj = {"ID": (ID), "FIO": (FIO), "DOB": (DOB) }
        do data.%Push(obj)
        }
        &sql(CLOSE MyCursor)
        
        quit
}

Storage Default
{
<Data name="ClientsDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>FIO</Value>
</Value>
<Value name="3">
<Value>Email</Value>
</Value>
<Value name="4">
<Value>Phone</Value>
</Value>
<Value name="5">
<Value>DOB</Value>
</Value>
</Data>
<DataLocation>^Company.ClientsD</DataLocation>
<DefaultData>ClientsDefaultData</DefaultData>
<IdLocation>^Company.ClientsD</IdLocation>
<IndexLocation>^Company.ClientsI</IndexLocation>
<StreamLocation>^Company.ClientsS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
