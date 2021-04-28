Class Company.Staff Extends (%Persistent, %Populate)
{

Property FIO As %String [ Required ];

Property Salary As %Integer(MAXVAL = 1000000, MINVAL = 1);

Property Position As %String;

Property Email As %String;

Property Phone As %String;

Property DOB As %Date;

Relationship Orders As Company.Orders [ Cardinality = many, Inverse = Staff ];

ClassMethod SaveStaff(staffObj As Company.Staff) As %Status
{
        set obj = ##class(Company.Staff).%New()

        set obj.FIO = staffObj.FIO
        set x = obj.FIOIsValid(obj.FIO)

        set obj.Salary = staffObj.Salary
        set x = obj.SalaryIsValid(obj.Salary)

        set obj.Position = staffObj.Position
        set x = obj.PositionIsValid(obj.Position)

        set obj.Email = staffObj.Email
        set x = obj.EmailIsValid(obj.Email)

        set obj.Phone = staffObj.Phone
        set x = obj.PhoneIsValid(obj.Phone)

        set obj.DOB = staffObj.DOB
        set x = obj.DOBIsValid(obj.DOB)

        set result = obj.%Save()
        return result
}

Method getAll(data) As %String
{
        set data = []
        &sql(
            DECLARE MyCursor CURSOR FOR
            SELECT ID, FIO, Position
            INTO :ID, :FIO, :Position
            FROM Company.Staff
        )
        &sql(OPEN MyCursor)
        
    FOR { 
        &sql(FETCH MyCursor)
        if (SQLCODE) quit

        set obj = {"ID": (ID), "FIO": (FIO), "Position": (Position)}
        do data.%Push(obj)
        }
        &sql(CLOSE MyCursor)
        
        quit
}

Storage Default
{
<Data name="StaffDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>FIO</Value>
</Value>
<Value name="3">
<Value>Salary</Value>
</Value>
<Value name="4">
<Value>Position</Value>
</Value>
<Value name="5">
<Value>Email</Value>
</Value>
<Value name="6">
<Value>Phone</Value>
</Value>
<Value name="7">
<Value>DOB</Value>
</Value>
</Data>
<DataLocation>^Company.StaffD</DataLocation>
<DefaultData>StaffDefaultData</DefaultData>
<IdLocation>^Company.StaffD</IdLocation>
<IndexLocation>^Company.StaffI</IndexLocation>
<StreamLocation>^Company.StaffS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
