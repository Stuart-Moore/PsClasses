#Objects all the way down:
#region
$string = 'Hello World'
$string | Get-Member

$date = Get-Date
$date | Get-Member

#PsCustomObjects issues
$obj1 = [PsCustomObject]@{
    PsTypeName = 'TestObj'
    fname = 'stuart'
    sname = 'moore'
    birthdate = '12/11/1975'
}

$obj2 = [PsCustomObject]@{
    PsTypeName = 'TestObj'
    fname = 'stuart'
    sname = 'moore'
    bertdate = '12/11/1975'
}

$obj1.PsObject.TypeNames
$obj2.PsObject.TypeNames

function Get-Birthdate {
    param (
        [PsTypeName('TestObj')]$inputObject
    )
    "Birthdate is $($inputObject.BirthDate)"
}

Get-BirthDate -inputObject $obj1
Get-BirthDate -inputObject $obj2
#endregion

#Classes - structure for a new object

class Person {
    [string] $FirstName
    [String] $SurName
    [datetime] $DateOfBirth
}

#Create a new Object with New-Object
$p = New-Object Person  

$p

$p.FirstName = 'Fred'
$p.SurName = 'Moore'
$p.DateOfBirth = (Get-Date).AddYears(-30)

$p

#Instantiate a new object
$p2 = [Person]::New()
$p2.FirstName = 'Fred'
$p2.SurName = 'Moore'
$p2.DateOfBirth = (Get-Date).AddYears(-30)

#So far so similar. But we can add a constructor
class Person {
    [string] $FirstName
    [String] $SurName
    [datetime] $DateOfBirth
    Person ()
    Person ([string]$FirstName, [string]$Surname){
        $this.FirstName = $FirstName
        $this.SurName = $Surname
    }
}

#Now we can do this
$p3 = [Person]::New('Stuart', 'Moore')

#But we can't do this
4
$p4 = [Person]::New('Stuart', 'Moore', '12/11/1975')

#We can have multiuple constuctors
class Person {
    [string] $FirstName
    [String] $SurName
    [datetime] $DateOfBirth
    Person ()
    Person ([string]$FirstName, [string]$Surname){
        $this.FirstName = $FirstName
        $this.SurName = $Surname
    }
    Person ([string]$FirstName, [string]$Surname, [datetime]$DateOfBirth){
        $this.FirstName = $FirstName
        $this.SurName = $Surname
        $this.DateOfBirth = $DateOfBirth
    }
}

$p4 = [Person]::New('Stuart', 'Moore', '12/11/1975')

#Can validate the parameters

class Person {
    [ValidatePattern('^[a-z]')]
    [string] $FirstName
    [ValidatePattern('^[a-z]')]
    [String] $SurName
    [datetime] $DateOfBirth
    Person ([string]$FirstName, [string]$Surname){
        $this.FirstName = $FirstName
        $this.SurName = $Surname
    }
    Person ([string]$FirstName, [string]$Surname, [datetime]$DateOfBirth){
        $this.FirstName = $FirstName
        $this.SurName = $Surname
        $this.DateOfBirth = $DateOfBirth
    }
}

$p4 = [Person]::New('a','1')

#Can add methods, make stuff happen:
class Person {
    [string] $FirstName
    [String] $SurName
    [datetime] $DateOfBirth
    Person (){}
    Person ([string]$FirstName, [string]$Surname){
        $this.FirstName = $FirstName
        $this.SurName = $Surname
    }
    Person ([string]$FirstName, [string]$Surname, [datetime]$DateOfBirth){
        $this.FirstName = $FirstName
        $this.SurName = $Surname
        $this.DateOfBirth = $DateOfBirth
    }
    [String]Fullname (){
        return $this.SurName+", "+$this.FirstName
    }
    [int]YearsOld (){
        return [Math]::Round(((Get-Date)-$This.DateOfBirth).days/365)
    }
}

$p6 = [Person]::New('stuart','Moore','12/11/1975')

$p6.Fullname()
$p6.YearsOld()


function Get-YearsOld {
    param(
        [Person]$person
    )
    "$($Person.FirstName) is $($Person.YearsOld()) old"
}

Get-YearsOld $p6

#Can we do this is PsCustomObject?

$personObject = [PsCustomObject]@{
    PsTypeName = 'PersonObject'
    FirstName = 'Stuart'
    Surname = 'Moore'
    DateOfBirth = [DateTime]'12/11/1975'
}
$sb = {
    return [Math]::Round(((Get-Date)-$This.DateOfBirth).days/365)
}

$method = @{
    MemberType = "ScriptMethod"
    InputObject = $personObject
    Name = "YearsOld"
    Value = $sb
}

Add-Member @method

$personObject
$personObject.YearsOld()
$personObject.PsObject.TypeNames 
function Get-ObjYearsOld {
    param(
        [PsTypeName('PersonObject')]$person
    )
    "$($Person.FirstName) is $($Person.YearsOld()) old"
}

Get-ObjYearsOld -person $personObject
Get-ObjYearsOld -person $p

#Inheritance

class Staff : Person {
    [string] $department
    [DateTime] $hireDate
    [int]YearsOfService() {
        return [Math]::Round((((Get-Date)-$this.HireDate).days)/365)
    }
    Staff (){}
    Staff ([string]$FirstName, [string]$Surname){
        $this.FirstName = $FirstName
        $this.SurName = $Surname
    }
    Staff ([string]$FirstName, [string]$Surname, [datetime]$DateOfBirth){
        $this.FirstName = $FirstName
        $this.SurName = $Surname
        $this.DateOfBirth = $DateOfBirth
    }
}

Enum StudentDepartment {
    Mathematics;
    Chemistry;
    Arts;
    History;
}
class Student : Person {
    [StudentDepartment]$department
    [DateTime]$enrolmentDate
    [int]YearsOfStudy() {
        return [Math]::Round((((Get-Date)-$this.enrolmentDate).days)/365)
    }
    Student (){}
    Student ([string]$FirstName, [string]$Surname){
        $this.FirstName = $FirstName
        $this.SurName = $Surname
    }
    Student ([string]$FirstName, [string]$Surname, [datetime]$DateOfBirth){
        $this.FirstName = $FirstName
        $this.SurName = $Surname
        $this.DateOfBirth = $DateOfBirth
    }
}

$s = [Staff]::New('Stuart','Moore','12/11/1975')
$s.hireDate = '12/09/2016'
$s.YearsOld()
$s.Fullname()
$s.YearsOfService()

$student = [Student]::New('Alice','Brooks','12/02/2000')
$student.department = 'history'

#Can do complex loads for object build
class Staff : Person {
    [string] $department
    [string] $userid
    [DateTime] $hireDate
    [int]YearsOfService() {
        return [Math]::Round((((Get-Date)-$this.HireDate).days)/365)
    }
    Staff (){}
    Staff ([int]$userid) {
        $inputObject = ConvertFrom-Csv -InputObject (Get-Content .\MOCK_DATA.csv)  | Where-Object {$_.id -eq $userid}
        $this.FirstName = $inputObject.first_name
        $this.SurName = $inputObject.last_name
        $this.DateOfBirth = [DateTime]$inputObject.DoB
        $this.userid = "STAFF-$($inputObject.ID)"
    }
    Staff ([string]$FirstName, [string]$Surname){
        $this.FirstName = $FirstName
        $this.SurName = $Surname
    }
    Staff ([string]$FirstName, [string]$Surname, [datetime]$DateOfBirth){
        $this.FirstName = $FirstName
        $this.SurName = $Surname
        $this.DateOfBirth = $DateOfBirth
    }
}

$staff = [Staff]::New('7')
$staff

