/// Description
Class API.REST Extends %CSP.REST
{

Parameter HandleCorsRequest = 1;

Parameter CONTENTTYPE = "application/json";

XData UrlMap [ XMLNamespace = "http://www.intersystems.com/urlmap" ]
{
<Routes>
  <Route Url="/test" Method="GET" Call="Test"/>

  <Route Url="/clients/create" Method="POST" Call="ClientSave"/>
  <Route Url="/clients/get" Method="GET" Call="ClientsGet"/>
  <Route Url="/clients/delete" Method="DELETE" Call="ClientDelete"/>
  <Route Url="/clients/getclient" Method="GET" Call="ClientGet"/>

  <Route Url="/reviews/create" Method="POST" Call="ReviewSave"/>
  <Route Url="/reviews/get" Method="GET" Call="Allget"/>
  <Route Url="/reviews/delete" Method="DELETE" Call="ReviewDelete"/>
  <Route Url="/reviews/getreview" Method="GET" Call="ReviewGet"/>

  <Route Url="/staff/create" Method="POST" Call="StaffSave"/>
  <Route Url="/staff/get" Method="GET" Call="getAllStaff"/>
  <Route Url="/orders/create" Method="POST" Call="OrderSave"/>
  <Route Url="/orders/get" Method="GET" Call="OrdersGet"/>

</Routes>
}

ClassMethod Test() As %Status
{
  Set currentDate = $ZDate($Now(), 3)
  Set obj = {"msg":"It works","today": (currentDate)}
  Write obj.%ToJSON()
  Return $$$OK
}

ClassMethod ClientSave() As %Status
{
  set obj = {}
  set obj.FIO = %request.Get("FIO")
  set obj.Email = %request.Get("Email")
  set obj.Phone = %request.Get("Phone")
  set obj.DOB = %request.Get("DOB")
  set saveResult = ##class(Company.Clients).SaveClient(obj)
  set result = {}
  if $$$ISERR(saveResult) {
      set result = {"result": false}
  }
  else {
      set result = {"result": true}
  }
  write result.%ToJSON()
  set ErrorMessage = ##class(%SYSTEM.Status).GetErrorText(saveResult)
  set result.message = ErrorMessage

  Return $$$OK
}

ClassMethod ClientsGet(ID As %Integer) As %Status
{
  Try {
        set obj = ##class(Company.Clients).%New()
        do obj.getClients(.clientsArray)
        write clientsArray.%ToJSON()
        Return $$$OK
  } Catch {
        set result = {"result": false}
        set result.message = "Error"
        write result.%ToJSON()
        Return $$$ERROR(500)
  }
}

ClassMethod ClientDelete() As %Status
{
    set ID = %request.Get("ID")
    set saveResult = ##class(Company.Clients).DeleteClient(ID)
    set result = {}
    if $$$ISERR(saveResult) {
       set result = {"result": false}
    }
    else {
       set result = {"result": true}
    }
    write result.%ToJSON()
    
    Return $$$OK
}

ClassMethod ClientGet() As %Status
{
    set ID = %request.Get("ID")
    try {
        set client = ##class(Company.Clients).GetClient(ID)
        set obj = {}
        set obj."DOB" = client.DOB
        set obj."FIO" = client.FIO
        set source = obj.%ToJSON()
	    write source
        Return $$$OK
    } Catch {
        Return $$$ERROR(404)
    }
}

ClassMethod ReviewSave() As %Status
{
    set obj = {}
    set obj.Review = %request.Get("Review")
    set saveResult = ##class(Company.Review).SaveCup(obj)

    set result = {}
    if $$$ISERR(saveResult) {
        set result = {"result": false}
    }
    else {
        set result = {"result": true}
    }
    write result.%ToJSON()
    set ErrorMessage = ##class(%SYSTEM.Status).GetErrorText(saveResult)
    set result.message = ErrorMessage

    Return $$$OK
}

ClassMethod Allget() As %Status
{
    Try {
        set obj = ##class(Company.Review).%New()
        do obj.getAll(.arr)
        write arr.%ToJSON()
        Return $$$OK
    } Catch {
        set result = {"result": false}
        set result.message = "Error"
        write result.%ToJSON()
        Return $$$ERROR(500)
    }
}

ClassMethod ReviewDelete() As %Status
{
    set ID = %request.Get("ID")
    set saveResult = ##class(Company.Review).DeleteReview(ID)

    set result = {}
    if $$$ISERR(saveResult) {
       set result = {"result": false}
    }
    else {
       set result = {"result": true}
    }
    write result.%ToJSON()
    
    Return $$$OK
}

ClassMethod ReviewGet() As %Status
{
    set ID = %request.Get("ID")
    try {
        set review = ##class(Company.Review).GetReview(ID)
        set obj = {}
        set obj."Review" = review.Review
        set source = obj.%ToJSON()
	      write source
        Return $$$OK
    } Catch {
        Return $$$ERROR(404)
    }
}

ClassMethod StaffSave() As %Status
{
    set obj = {}
    set obj.FIO = %request.Get("FIO")
    set obj.Salary = %request.Get("Salary")
    set obj.Position = %request.Get("Position")
    set obj.Email = %request.Get("Email")
    set obj.Phone = %request.Get("Phone")
    set obj.DOB = %request.Get("DOB")
    set saveResult = ##class(Company.Staff).SaveStaff(obj)
    
    set result = {}
    if $$$ISERR(saveResult) {
        set result = {"result": false}
    }
    else {
        set result = {"result": true}
    }
    write result.%ToJSON()
    set ErrorMessage = ##class(%SYSTEM.Status).GetErrorText(saveResult)
    set result.message = ErrorMessage

    return $$$OK
}

ClassMethod getAllStaff() As %Status
{
    Try {
        set obj = ##class(Company.Staff).%New()
        do obj.getAll(.arr)
        write arr.%ToJSON()
        Return $$$OK
    } Catch {
        set result = {"result": false}
        set result.message = "Error"
        write result.%ToJSON()
        Return $$$ERROR(500)
    }
}

ClassMethod OrderSave() As %Status
{
    set obj = {}
    set obj.Details = %request.Get("Details")
    set obj.Status = %request.Get("Status")
    set saveResult = ##class(Company.Orders).SaveOrder(obj)
    
    set result = {}
    if $$$ISERR(saveResult) {
        set result = {"result": false}
    }
    else {
        set result = {"result": true}
    }
    write result.%ToJSON()
    set ErrorMessage = ##class(%SYSTEM.Status).GetErrorText(saveResult)
    set result.message = ErrorMessage

    return $$$OK
}

ClassMethod OrdersGet() As %Status
{
    Try {
        set obj = ##class(Company.Orders).%New()
        do obj.GetOrders(.arr)
        write arr.%ToJSON()
        Return $$$OK
    } Catch {
        set result = {"result": false}
        set result.message = "Error"
        write result.%ToJSON()
        Return $$$ERROR(500)
    }
}

}
