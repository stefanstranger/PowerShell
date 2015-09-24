<#
            /'=----=           ______
            ((    ||          "--.__."
             "  @>||_____________//
          _______ /^\"""""""""""//\========)
         _--"""--/-. "\        // _\-:::-/_-.
       ." .-"""-/ "_\  "\  == // ;::\:::/::".\
      ; /     _/ "  \\   "\-+//--..._\_/:::::\\
      . ;    o    . ||   ( ()/)======(o)::::::.
      . \         ; .|    -|.;____...."b:::::;
       . -._  _ -  ;       ==    :::::::::::;
        "-..____.'     ls         ":::::::'

Credits: http://chris.com/ascii/index.php?art=transportation/bicycles

Properties bicycle:
    NumberOfWheels
    Direction
    Status
    Brand

Methods Bicycle
    Brake
    Cycle
    Steer
#>


$source = @" 
public class Bicycle 
{ 
    public Bicycle(string constructorBrand) //default constructor
    {

        brand = constructorBrand;
    }
    
    //properties
    private string status = "stopped";
    private string direction = "straight";
    private string brand;
    
    public static int NumberOfWheels = 2;

    //When Brake method is called Property Status is changed to "stopped"
    public string Brake () 
	{ 
        return status = "stopped";
	} 
    
    //When Cycle method is called Property Status is changed to "running'
    public string Cycle () 
	{ 
        return status = "running";
	} 

    // When Steer method is called the Property Direction is set.
    public string Steer(string a)
    {
        return direction = a;
    }

 
    // Status is a property which returns if the bicyle is stopped or running.
    public string Status
	{
        get
        {
	        return this.status;
        }
        set
        {
            this.status = value;
        }
	}

    // Direction is a property which returns the direction of the bicylce ("straight","left", "right").
    public string Direction
	{
        get
        {
	        return this.direction;
        }
        set
        {
            this.direction = value;
        }
	}

    // Brand is a property which returns the brand of the bicylce.
    public string Brand
	{
        get
        {
	        return this.brand;
        }
        set
        {
            this.brand = value;
        }
	}

} 
"@

# Use Add-Type to compile the C# source code stored in $source here-string
Add-Type -TypeDefinition $source 


# Class: defines characteristics of an object
# For the Bicycle you can see it has some properties, like number of wheels, direction, status or brand and
# methods (what you can do with it), like cycle, brake and steer.
# So if it has two wheels, a direction, is running or stopped and a brand and you can steer etc. it's a bicycle. 


# Instance: an object is an instance of a particular class.
# create a new instance of the class bicycle using a Constructor
$MyBike = New-Object -TypeName Bicycle("Gazelle")


# What are the members of the object we just created?
$MyBike | Get-Member

# If we want to find the static members of the object we just created we do the following.
$MyBike | Get-Member -Static

# Let's get cycling calling the Cycle method.
$MyBike.Cycle()

# We are approaching a stop sign let's hit the brakes
$MyBike.Brake()

# Finally let's continue with Cycle and turn left
$MyBike.Cycle()
$MyBike.Steer("left")

# We can also create a collection (array) of bicycle objects.
# Create an empty array
$Bikes = @()

# Add bicycle objects to the bikes array.
$Bikes += $MyBike

# Create a new instance of the class bicycle
$YourBike = New-Object -TypeName Bicycle("Sparta")
$Bikes += $YourBike

