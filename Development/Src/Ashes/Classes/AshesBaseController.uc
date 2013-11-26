class AshesBaseController extends UTPlayerController
	config(Game);

/**minimum distance of the camera to the pawn*/
var float fMinCameraDistance;
/**maximum distance of the camera to the pawn*/
var float fMaxCameraDistance;

var Vector MouseWorldOrigin, MouseWorldDirection;

var MeshMouseCursor MouseCursor; 

simulated event PostBeginPlay()
{
	super.PostBeginPlay();

	MouseCursor = Spawn(class 'MeshMouseCursor', self, 'marker');
}

function Rotator GetAdjustedAimFor(Weapon W, Vector StartFireLoc)
{
	local Rotator   targetRotation;
	local Vector    aimStartPos;
	local float     hitLength;
	local Vector PlaneHitPos;
	local AsheHUD ashHUD;

	ashHUD = AsheHUD(myHUD);
   
	if (self.Pawn != None)
	{
		aimStartPos = self.Pawn.GetPawnViewLocation();      

		hitLength = -((vect(0,0,1) dot (ashHUD.WorldMousePosition - aimStartPos)) / (vect(0,0,1) dot ashHUD.WorldMouseDirection));
		PlaneHitPos = (ashHUD.WorldMousePosition + ashHUD.WorldMouseDirection * hitLength);
 
		targetRotation = pawn.GetBaseAimRotation();
		targetRotation.Yaw = rotator(PlaneHitPos - aimStartPos).Yaw; // only update yaw


		`log(targetRotation);
		return targetRotation;
	}
}

event PlayerTick( float DeltaTime )
{
	local AsheHUD ashHUD;
    super.PlayerTick(DeltaTime);

    //Set the location of the 3d marker that moves with the mouse.

	ashHUD = AsheHUD(myHUD);
    MouseCursor.SetLocation(ashHUD.WorldMousePosition);
}

exec function ShowMenu()
{
	ConsoleCommand("quit");
}

//Wrapper for zooming in
exec function NextWeapon() 
{
	//local UTWeapon NewWeapon;
	
	//Pawn.InvManager.CreateInventory(class'UTWeap_LinkGun');
	//NewWeapon = Spawn(Class'UTWeap_LinkGun');
	//NewWeapon.GiveTo(Pawn);
	Zoom(64,1);
}

//Wrapper for zooming out
exec function PrevWeapon()
{
	Zoom(-64,1);
}

/**Zoom the camera (modify distance of the camera to the Pawn)
 * 
 * @param   _fZoom          the distance amount to zoom
 * @param   _fDeltaTime     the delta time
 */
final exec function Zoom(float _fZoom, optional float _fDeltaTime)
{
	local float fNewZoom;
	local float fScale;

	//set scale to 1 in case delta time is zero
	fScale = _fDeltaTime == 0 ? 1.0f : _fDeltaTime;
	//calculate the zoom
	
	fNewZoom = PlayerCamera.FreeCamDistance += fScale * _fZoom;
	fNewZoom = FClamp(fNewZoom,fMinCameraDistance,fMaxCameraDistance);

	//set the zoom
	PlayerCamera.FreeCamDistance = fNewZoom;

	
}


function UpdateRotation(float DeltaTime)
{
   local Rotator   targetRotation;
   local Vector    aimStartPos;
   local float     hitLength;
   local Vector PlaneHitPos;
   local AsheHUD ashHUD;

   ashHUD = AsheHUD(myHUD);
   
	if (self.Pawn != None)
	{
		aimStartPos = self.Pawn.GetPawnViewLocation();      

		hitLength = -((vect(0,0,1) dot (ashHUD.WorldMousePosition - aimStartPos)) / (vect(0,0,1) dot ashHUD.WorldMouseDirection));
		PlaneHitPos = (ashHUD.WorldMousePosition + ashHUD.WorldMouseDirection * hitLength);
 
		targetRotation = pawn.GetBaseAimRotation();
		targetRotation.Yaw = rotator(PlaneHitPos - aimStartPos).Yaw; // only update yaw

		Pawn.FaceRotation(targetRotation, DeltaTime);
	}
	else
	{
		super.UpdateRotation(DeltaTime);
	}
}

event ResetCameraMode()
{
	if ( Pawn != None )
	{	// If we have a pawn, let's ask it which camera mode we should use
		SetCameraMode( Pawn.GetDefaultCameraMode( Self ) );
	}
	else
	{	
		SetCameraMode( 'ThirdPerson' );
	}
}

event Tick(float DeltaTime)
{
	`log("TACK");
	super.Tick(DeltaTime);
}

DefaultProperties
{
	InputClass=Class'Ashes.AshesInput'
	CameraClass=class'Ashes.AshesCamera'
	fMinCameraDistance = 64
	fMaxCameraDistance = 512
	
	
}
