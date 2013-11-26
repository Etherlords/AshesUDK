class AshesBasePawn extends UTPawn
config(Game);

simulated singular event Rotator GetBaseAimRotation()
{
   local rotator POVRot;

   POVRot = Rotation;
   POVRot.Pitch = 0;

   return POVRot;
}   

simulated function Rotator GetAdjustedAimFor( Weapon W, vector StartFireLoc )
{
	// If controller doesn't exist or we're a client, get the where the Pawn is aiming at
	if ( Controller == None || Role < Role_Authority )
	{
		return GetBaseAimRotation();
	}

	// otherwise, give a chance to controller to adjust this Aim Rotation
	return Controller.GetAdjustedAimFor( W, StartFireLoc );
}

simulated function name GetDefaultCameraMode(PlayerController RequestedBy)
{
	if ( RequestedBy != None && RequestedBy.PlayerCamera != None && RequestedBy.PlayerCamera.CameraStyle == 'Fixed' )
		return 'Fixed';

	return 'ThirdPerson';
}

DefaultProperties
{
	//IsoCamAngle=8000 //6420 = 35.264 degrees Change this number for the camera angle
}

/*DefaultProperties
{

	//Components.Remove(Sprite)
	Components.Remove(CollisionCylinder)

	begin object Class=CylinderComponent Name=CylComponent
		CollisionRadius =+ 40.0
		CollisionHeight = 50.0
		end object

	Components.Add(CylComponent)
	CylinderComponent = CylComponent
	CollisionComponent = CylComponent

	//Skeletal Mesh component. Our character mesh
	Begin Object Class=SkeletalMeshComponent Name=MyPawnSkeletalMesh
		CollideActors=true
		BlockRigidBody=true
		bHasPhysicsAssetInstance=true
		bUpdateKinematicBonesFromAnimation=false
		//The only skeletal mesh in the custom installation
		SkeletalMesh=SkeletalMesh'CH_LIAM_Cathode.Mesh.SK_CH_LIAM_Cathode'
		//AnimSets are the animation collection to use by this mesh.
		//The udk package should be under UDKGame/Content. Right click on the animset in the content browser and
		//copy full name to clipboard.
		//There is no animset in the custom installation ready
		
		AnimSets(0)=AnimSet'CH_AnimHuman.Anims.K_AnimHuman_AimOffset'
		AnimSets(1)=AnimSet'CH_AnimHuman.Anims.K_AnimHuman_BaseMale'
		//The same for the animtre
		AnimTreeTemplate=AnimTree'UTExampleCrowd.AnimTree.AT_CH_Crowd'
		PhysicsAsset=PhysicsAsset'CH_AnimCorrupt.Mesh.SK_CH_Corrupt_Male_Physics'
		//HiddenGame=FALSE
		//HiddenEditor=FALSE
	End Object

	Mesh=MyPawnSkeletalMesh
	//Add it to the Actor’s components
	//CollisionComponent = MyPawnSkeletalMesh
	Components.Add(MyPawnSkeletalMesh)
	//CollisionType=COLLIDE_BlockAll

	//Very important if we don’t want our character embracing the shadows forever
	/*Begin Object Class=DynamicLightEnvironmentComponent Name=MyLightEnvironment
		//Different flags from the component
		bIsCharacterLightEnvironment=TRUE
		bSynthesizeSHLight=TRUE
	End Object
	//Adding the component again
	Components.Add(MyLightEnvironment)*/

	
	/*Components.Remove(Sprite)

 	Begin Object Class=DynamicLightEnvironmentComponent Name=MyLightEnvironment
		bSynthesizeSHLight=true
		bUseBooleanEnvironmentShadowing=false
		ModShadowFadeoutTime=0.75f
		bIsCharacterLightEnvironment=true
		bAllowDynamicShadowsOnTranslucency=true
 	End Object
 	Components.Add(MyLightEnvironment)

 	Begin Object Class=SkeletalMeshComponent Name=MySkeletalMeshComponent
		CollideActors=true
		BlockRigidBody=true
		bHasPhysicsAssetInstance=true
		bUpdateKinematicBonesFromAnimation=false
		MinDistFactorForKinematicUpdate=0.f
		LightEnvironment=MyLightEnvironment
 	End Object
 	Mesh=MySkeletalMeshComponent
 	Components.Add(MySkeletalMeshComponent)

	Begin Object Class=SkeletalMeshComponent Name=MyWeaponSkeletalMeshComponent
		CollideActors=false
		BlockRigidBody=false
		bHasPhysicsAssetInstance=false
		bUpdateKinematicBonesFromAnimation=false
		MinDistFactorForKinematicUpdate=0.f
		LightEnvironment=MyLightEnvironment
	End Object
	//WeaponSkeletalMesh=MyWeaponSkeletalMeshComponent
	Components.Add(MyWeaponSkeletalMeshComponent)

	Begin Object Class=SkeletalMeshComponent Name=MyOcclusionSkeletalMeshComponent
		CollideActors=false
		BlockRigidBody=false
		bHasPhysicsAssetInstance=false
		bUpdateKinematicBonesFromAnimation=false
		MinDistFactorForKinematicUpdate=0.f
		ParentAnimComponent=MySkeletalMeshComponent
		bUseBoundsFromParentAnimComponent=true
		DepthPriorityGroup=SDPG_Foreground
		
	End Object
	//OcclusionSkeletalMeshComponent=MyOcclusionSkeletalMeshComponent*/

	Begin Object Class=SkeletalMeshComponent Name=MyOcclusionSkeletalMeshComponent
		CollideActors=false
		BlockRigidBody=false
		bHasPhysicsAssetInstance=false
		bUpdateKinematicBonesFromAnimation=false
		MinDistFactorForKinematicUpdate=0.f
		ParentAnimComponent=MySkeletalMeshComponent
		bUseBoundsFromParentAnimComponent=true
		DepthPriorityGroup=SDPG_Foreground
		
	End Object


	PendingFre(0)=0
	PendingFre(1)=0

	InventoryManagerClass = class'UTInventoryManager'
	//DefaultInventory(0) = class'UTGame.UTWeap_LinkGun'

	
	
	
}    */