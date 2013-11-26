class TitanicClashNetController extends TCPLink;

function initialize()
{
	`log("## INIT TCP LINK");
	Resolve("PLANETVEGETA");
}

event ReceivedText(string Text)
{
	`log("recive text");
	`log(Text);
	super.ReceivedText(Text);
}

event ReceivedBinary(int Count, byte B[255])
{
	local int i;
	`log("receive bytes");
	
	for(i = 0; i < Count; i++)
	{
		`log(B[i]);
	}

	`log('----------');
	`log(Count);
}

event Resolved(IpAddr Addr)
{
	`log("HOST RESOVLED");
	`log(Addr.Addr);

	self.LinkMode = MODE_Binary;
	
	Addr.Port = 8881;	
	BindPort();

	if(!Open(Addr))
		`log("Canr open current addr");
	else
		`log("Process open");

	super.Resolved(Addr);
}

event ResolveFailed()
{
	`log("Resolving is fail");
	super.ResolveFailed();
}

event Opened()
{
	`log("## CONNECTION OPPENDED");
	super.Opened();
}

event Closed()
{
	`log("## CLOSED CONNECTION");
	super.Closed();
}

defaultproperties
{

}
