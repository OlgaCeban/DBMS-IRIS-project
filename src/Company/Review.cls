Class Company.Review Extends %Persistent
{
    /// Description
    Property Review As %String;

    Relationship Clients As Company.Staff(%JSONINCLUDE = "none") [Cardinality = one, Inverse = Review];


    ClassMethod SaveReview(ReviewObj As Company.Review) As %Status
    {
        set obj = ##class(Company.Review).%New()
        
        set obj.Review = ReviewObj.Review
        set x = obj.ReviewIsValid(obj.Review)

        set result = obj.%Save()
        Return result
    }

    ClassMethod DeleteReview(ID As %Integer) As %Status
    {
        set result = ##class(Company.Review).%DeleteId(ID)
        Return result
    }

    ClassMethod GetReview(ID As %Integer) As Company.Review
    {
        set obj = ##class(Company.Review).%OpenId(ID)
        Return obj
    }

    Method getAll(data) As %String
    {
        set data = []
        &sql(
            DECLARE MyCursor CURSOR FOR
            SELECT ID, Review
            INTO :ID, :Review
            FROM Company.Review
        )
        &sql(OPEN MyCursor)
        
    FOR { 
        &sql(FETCH MyCursor)
        if (SQLCODE) quit

        set obj = {"id": (ID), "Review": (Review)}
        do data.%Push(obj)
        }
        &sql(CLOSE MyCursor)
        
        quit
    }
}