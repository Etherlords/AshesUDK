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
	local ByteArray barr;

	barr = new class'ByteArray';

	`log("receive bytes");
	
	for(i = 0; i < Count; i++)
	{
		barr.writeByte(b[i]);
	}

	barr.position = 0;

	`log(barr.readInt());
	`log(barr.readInt());
	`log(barr.readUTF());

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
