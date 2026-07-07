select name from Employee as E where E.id in (select max(managerId) from Employee as e group by e.
managerId having (COUNT(e.managerId)>=5));