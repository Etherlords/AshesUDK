class MouseGlobal extends Object;

static function bool MouseToWorldCoordinates(HUD HUD, out Vector out_HitLocation, out Vector out_HitNormal)
{
	local WorldInfo WorldInfo;
	local PlayerController PlayerController;
	local LocalPlayer LocalPlayer;

	WorldInfo = class'WorldInfo'.static.GetWorldInfo();

	if (WorldInfo == None)
	{
		return false;
	}

	PlayerController = WorldInfo.GetALocalPlayerController();
	if (PlayerController == None)
	{
		return false;
	}

	LocalPlayer = LocalPlayer(PlayerController.Player);
	if (LocalPlayer == None || LocalPlayer.ViewportClient == None)
	{
		return false;
	}

	return ScreenSpaceCoordinatesToWorldCoordinates(HUD, LocalPlayer.ViewportClient.GetMousePosition(), out_HitLocation, out_HitNormal);
}

static function bool ScreenSpaceCoordinatesToWorldCoordinates(HUD HUD, Vector2D ScreenSpaceLocation, out Vector out_HitLocation, out Vector out_HitNormal)
{
	local Vector WorldOrigin, WorldDirection;

	
	// Get the deprojection coordinates from the screen location
	HUD.Canvas.Deproject(ScreenSpaceLocation, WorldOrigin, WorldDirection);

	return GetHitCoordinates(WorldOrigin, WorldDirection, out_HitLocation, out_HitNormal);
	
}

static function bool GetHitCoordinates(vector WorldOrigin, vector WorldDirection, out Vector out_HitLocation, out Vector out_HitNormal)
{
	local vector HitLocation, HitNormal;
	local Actor Actor;
	local WorldInfo WorldInfo;

	WorldInfo = class'WorldInfo'.static.GetWorldInfo();
	if (WorldInfo == None)
	{
		return false;
	}

	ForEach WorldInfo.TraceActors(class'Actor', Actor, HitLocation, HitNormal, WorldOrigin + WorldDirection * 16384.f, WorldOrigin)
	{
		if (ShouldBlockMouseWorldTrace(Actor))
		{
			out_HitLocation = HitLocation;
			out_HitNormal = HitNormal;
			return true;
		}
	}

	return false;
}

static function bool ShouldBlockMouseWorldTrace(Actor Actor)
{
	return (WorldBlockingVolume(Actor) != None || WorldInfo(Actor) != None);
}

DefaultProperties
{
}
