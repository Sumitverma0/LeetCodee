select b.name as Employee from Employee e join Employee b on (e.id=b.managerId) where b.salary>e.
salary;
