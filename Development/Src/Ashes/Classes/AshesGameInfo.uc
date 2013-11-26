class AshesGameInfo extends UTGame
	config(Game);

var TitanicClashNetController netController;

static event class<GameInfo> SetGameType(string MapName, string Options, string Portal)
{
	return default.class;
}

auto State PendingMatch
{
	Begin:
	StartMatch();
}


event InitGame(string Options, out string ErrorMessage)
{
	`log("######## INIT GAME ##########");
	super.InitGame(Options, ErrorMessage);
	
	netController = Spawn(class'TitanicClashNetController');
	netController.initialize();
}

function RestartPlayer(Controller NewPlayer)
{

	`log("######## restart player ##########");
	`log(NewPlayer);
	
	super.RestartPlayer(NewPlayer);
	AddDefaultInventory(NewPlayer.Pawn);

	//NewPlayer.Pawn.Mesh.SetSkeletalMesh(SkeletalMesh'CH_IronGuard_Male.Mesh.SK_CH_IronGuard_MaleA');
	//NewPlayer.Pawn.Mesh.SetMaterial(0, MaterialInstanceConstant'CH_IronGuard_Male.Materials.MI_CH_IronG_MHead01_V01');
	//NewPlayer.Pawn.Mesh.SetMaterial(1, MaterialInstanceConstant'CH_IronGuard_Male.Materials.MI_CH_IronG_Mbody01_V01');
	//NewPlayer.Pawn.Mesh.SetPhysicsAsset(PhysicsAsset'CTF_Flag_IronGuard.Mesh.S_CTF_Flag_IronGuard_Physics');
	


}

DefaultProperties
{
	bUseClassicHUD=true
	HUDType=class'Ashes.AsheHUD'
	DefaultPawnClass = class'Ashes.AshesBasePawn'
	PlayerControllerClass = class'Ashes.AshesBaseController'
	//PlayerControllerClass = class'UTPlayerController'
	bDelayedStart = false
}  
