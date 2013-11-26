class AsheHUD extends UTHUD;


var const Texture2D CursorTexture; 
var const Color CursorColor;

var Vector WorldMouseOrigin, WorldMouseDirectionOrigin, WorldMousePosition, WorldMouseDirection;
var Vector2D MousePosition;

event PostRender()
{
	updateMousePosition();
	DrawMouse();

	super.PostRender();
}

function DrawMouse()
{
	// Ensure that we have a valid PlayerOwner and CursorTexture
	if (PlayerOwner != None && CursorTexture != None) 
	{
		Canvas.SetPos(MousePosition.X, MousePosition.Y); 
		Canvas.DrawColor = CursorColor;
		Canvas.DrawTile(CursorTexture, CursorTexture.SizeX, CursorTexture.SizeY, 0.f, 0.f, CursorTexture.SizeX, CursorTexture.SizeY,, true);
	}

}

function updateMousePosition()
{
	local LocalPlayer LocalPlayer;
	local PlayerController PlayerController;

	PlayerController = PlayerOwner.GetALocalPlayerController();

	LocalPlayer = LocalPlayer(PlayerController.Player);

	if (LocalPlayer == None || LocalPlayer.ViewportClient == None)
	{
		return;
	}

	MousePosition = LocalPlayer.ViewportClient.GetMousePosition();
	updateWorldMousePosition();
}

function updateWorldMousePosition()
{
	if (Canvas == None || PlayerOwner == None)
	{
		return;
	}

	Canvas.DeProject(MousePosition, WorldMouseOrigin, WorldMouseDirectionOrigin);

	class'MouseGlobal'.static.GetHitCoordinates(WorldMouseOrigin, WorldMouseDirectionOrigin, WorldMousePosition, WorldMouseDirection);

	//Trace(WorldMousePosition, WorldMouseDirection, WorldMouseOrigin + WorldMouseDirectionOrigin * 65536.f, WorldMouseOrigin , true,,, TRACEFLAG_Bullet);
}

static function bool ShouldBlockMouseWorldTrace(Actor Actor)
{
	return (WorldBlockingVolume(Actor) != None || WorldInfo(Actor) != None);
}

DefaultProperties
{
	CursorColor=(R=255,G=255,B=255,A=255)
	CursorTexture=Texture2D'EngineResources.Cursors.Arrow'
}
