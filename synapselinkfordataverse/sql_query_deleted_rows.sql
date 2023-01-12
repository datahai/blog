--based on Dynamics 365 CRM test data

;WITH deletedrows
AS
(
    SELECT 
        Id,
        SinkCreatedOn,
        IsDelete
    FROM contact
    WHERE IsDelete = 'True'
)
SELECT 
    c.Id,
    c.contactid,
    c.fullname,    
    c.SinkCreatedOn,   
    d.IsDelete,
    d.SinkCreatedOn AS deletedon
FROM contact c
LEFT JOIN deletedrows d ON c.Id = d.Id
WHERE c.IsDelete IS NULL AND c.fullname = 'Avery Howard'
ORDER BY c.Id;
