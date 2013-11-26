/**
 * Camera that provides third person functionality for the "classic" third person view
 * 
 * Thanks a bunch to Psilocybe for this tutorial:
 * http://forums.epicgames.com/threads/726985-Tutorial-Third-Person-Game-with-GOW-camera
 * Note that I only use the basic functionality explained in the tutorial, 
 * take a look to find out more!
 * 
 * 2013 by FreetimeCoder
 * www.freetimestudio.net
 */
class AshesCamera extends Camera;


var Vector MovementPlane;
var Vector MovementPlaneNormal;
var Rotator CameraAXIS;
var int BlendSpeed;

/**
 * to provide smooth zoom FreeCamDistance is used as the target value
 * in Lerp, while fActualFreeCAmDistance holds the current distance
 */
var float fActualFreeCamDistance;

/**
 * how fast to lerp the camera distance
 */
var float fZoomSpeed;

/**
 * an offset value from the water surface in global Z Axis. Setting the 
 * camera directly onto the surface Z would cause clipping errors
 */
var float fWaterSurfaceOffset;

/**
 * whether or not to let the camera collide with the water surface
 */
var bool bCollideWithWaterSurface;

var ProtectedWrite Vector DesiredCameraLocation;
var bool IsTrackingHeroPawn;

function SetDesiredCameraLocation(Vector NewDesiredCameraLocation)
{
	DesiredCameraLocation = NewDesiredCameraLocation;
}



/**Camera.uc:
 * Query ViewTarget and outputs Point Of View.
 *
 * @param	OutVT		ViewTarget to use.
 * @param	DeltaTimew Delta Time since last camera update (in seconds).
 */
 function UpdateViewTarget(out TViewTarget OutVT, float DeltaTime)
{
	local vector	    HitLocation, HitNormal;
	local Actor			HitActor;

	local vector vViewTargetLocation;
	local Vector newLocation;
	//local Vector CameraDirectionX, CameraDirectionY, CameraDirectionZ;
	local Rotator newRotation;
	local CameraActor CamActor;

	OutVT.POV.FOV = DefaultFOV;
	
	/** NOTE Copycat code that makes Matinee work -- I have no idea what I am doing, just copied this over from the Camera.uc **/
	// Don't update outgoing viewtarget during an interpolation 
	if( PendingViewTarget.Target != None && OutVT == ViewTarget && BlendParams.bLockOutgoing )
	{
		return;
	}
	// Viewing through a camera actor.
	CamActor = CameraActor(OutVT.Target);
	if( CamActor != None )
	{
		CamActor.GetCameraView(DeltaTime, OutVT.POV);

		// Grab aspect ratio from the CameraActor.
		bConstrainAspectRatio	= bConstrainAspectRatio || CamActor.bConstrainAspectRatio;
		OutVT.AspectRatio		= CamActor.AspectRatio;

		// See if the CameraActor wants to override the PostProcess settings used.
		CamOverridePostProcessAlpha = CamActor.CamOverridePostProcessAlpha;
		CamPostProcessSettings = CamActor.CamOverridePostProcess;
		return;
	}
	/** End of copycat code **/

	//Just take a look at the tutorial code
	vViewTargetLocation = OutVT.Target.Location;
	newLocation = vViewTargetLocation;
	newRotation = OutVT.Target.Rotation;

	CameraStyle = Name("RPG");

	if (CameraStyle == 'ThirdPerson' || CameraStyle == 'Swimming' || CameraStyle == 'Diving')
	{
		newRotation = PCOwner.Rotation; //setting the rotation of the camera to the rotation of the controller
		
		vViewTargetLocation += FreeCamOffset >> newRotation;
		if(fActualFreeCamDistance != FreeCamDistance)
		{
			fActualFreeCamDistance = Lerp(fActualFreeCamDistance,FreeCamDistance,FMin(1,fZoomSpeed*DeltaTime));
		}

		newLocation = vViewTargetLocation - Vector(newRotation)*fActualFreeCamDistance;
		newLocation.X += sin(-newRotation.Yaw * UnrRotToRad);
		newLocation.Y += cos(newRotation.Yaw * UnrRotToRad);

		HitActor = Trace(HitLocation, HitNormal, newLocation, vViewTargetLocation, FALSE, vect(12,12,12));
		newLocation = (HitActor == None) ? newLocation : HitLocation;
	}
	else if(CameraStyle == 'RPG')
	{
		newRotation.Pitch = (-55.0f     *DegToRad) * RadToUnrRot;
		newRotation.Roll =  (0          *DegToRad) * RadToUnrRot;
		newRotation.Yaw =   (30.0f      *DegToRad) * RadToUnrRot;

		vViewTargetLocation.X = PCOwner.Pawn.Location.X - 64;
		vViewTargetLocation.Y = PCOwner.Pawn.Location.Y - 64;
		vViewTargetLocation.Z = PCOwner.Pawn.Location.Z + 156;

		newLocation = vViewTargetLocation - Vector(newRotation) * FreeCamDistance;
	}

	
	OutVT.POV.Rotation = newRotation;
	OutVT.POV.Location = newLocation;

	//SetRotation(newRotation);
	
	//if( !bDoNotApplyModifiers )
	//{
		// Apply camera modifiers at the end (view shakes for example)
		ApplyCameraModifiers(DeltaTime, OutVT.POV);
	//}
}

static function bool LinePlaneIntersection(Vector LineA, Vector LineB, Vector PlanePoint, Vector PlaneNormal, out Vector IntersectionPoint)
{
	local Vector U, W;
	local float D, N, sI;

	U = LineB - LineA;
	W = LineA - PlanePoint;

    D = PlaneNormal dot U;
    N = (PlaneNormal dot W) * -1.f;

    if (Abs(D) < 0.000001f)
	{
		return false;
	}

	sI = N / D;
	if (sI < 0.f || sI > 1.f)
	{
		return false;
	}

	IntersectionPoint = LineA + sI * U;
	return true;
}

Defaultproperties
{

	DefaultFOV = 90.f

	BlendSpeed = 7.5

	MovementPlaneNormal = (x=0, y=0, z=1)
	MovementPlane = (x=0, y=0, z=1440)
	CameraAXIS=(Yaw=24575, Pitch=32768)


	bCollideWithWaterSurface=true
	FreeCamDistance = 256.f
	fZoomSpeed = 10
	FreeCamOffset=(Z=32)
	fWaterSurfaceOffset=8
}