class Person {
    [string] $FirstName
    [String] $SurName
    [datetime] $DateOfBirth
}

#Create a new variable with New-Object
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

#Inheritance

class Staff : Person {
    [string] $department
    [DateTime] $hireDate
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

class Student : Person {

}

$s = [Staff]::New('Stuart','Moore','12/11/1975')
$s.YearsOld()
$s.Fullname()