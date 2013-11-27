class ByteArray extends Object;

const BYTE_MAX = 256;
const INT_SIZE = 4;
const LONG_SIZE = 8;

var array<byte> buffer;

var int position;
var int length;

public function cut(int from)
{
	//length = length-from;
	//local byte cutBuffer[length];
	
	//if(position > length)
	//	position = length;

	//System.arraycopy(buffer, from, buffer, 0, length);
	//System.arraycopy(cutBuffer, 0, buffer, length, length);
}

public function writeByte(byte b)
{
	buffer[position] = b;
	position++;

	if(position>=length)
		length = position;
}

public function byte readByte()
{
	return buffer[position++];
}

/* @Note udc not support long type only int, if long is neccessary probaly we can use 2 int some line struct or class with overriden "=-* etc.."
public function writeLong(long v)
{
	writeByte(byte  (v >>> 56));
	writeByte(byte  (v >>> 48));
	writeByte(byte  (v >>> 40));
	writeByte(byte  (v >>> 32));
	writeByte(byte  (v >>> 24));
	writeByte(byte  (v >>> 16));
	writeByte(byte  (v >>>  8));
	writeByte(byte  (v));
}
*/

public function writeInt(int v)
{
	writeByte(byte ((v >>> 24) & 0xFF));
	writeByte(byte ((v >>> 16) & 0xFF));
	writeByte(byte ((v >>>  8) & 0xFF));
	writeByte(byte ((v) & 0xFF));
}

public function int readInt()
{

	local int ch1, ch2, ch3, ch4;

	ch1 = readByte();
	ch2 = readByte();
	ch3 = readByte();
	ch4 = readByte();

	if(ch1 < 0)
		ch1 = BYTE_MAX + ch1;

	if(ch2 < 0)
		ch2 = BYTE_MAX + ch2;

	if(ch3 < 0)
		ch3 = BYTE_MAX + ch3;

	if(ch4 < 0)
		ch4 = BYTE_MAX + ch4;

	return ((ch1 << 24) + (ch2 << 16) + (ch3 << 8) + (ch4));
}

//course short can be writen in int
public function writeShort(int v)
{
	writeByte(byte ((v >>> 8) & 0xFF));
	writeByte(byte ((v) & 0xFF));
}

public function int readShort() 
{
	local int ch1, ch2;
	ch1 = readByte();
	ch2 = readByte();

	if(ch1 < 0)
		ch1 = BYTE_MAX + ch1;

	if(ch2 < 0)
		ch2 = BYTE_MAX + ch2;

	if ((ch1 | ch2) < 0)
		`warn("EOFException");

	return (ch1 << 8) + (ch2);
}

public function array<byte> read(int offset, int len)
{
	local array<byte> to;
	local int index, i;

	len+=offset;
	
	for(i = offset; i < len && i < self.length; i++)
	{
		
		to[index] = buffer[i];
		index++;
	}

	return to;
}

public static function int utfSizeOf(String str)
{
	local int strlen, utflen, c, i;

	strlen = Len(str);
	utflen = 0;
	c = 0;

    /* use charAt instead of copying String to char array */
	for (i = 0; i < strlen; i++) {
		c = Asc(Mid(str, i, 1));
		if ((c >= 0x0001) && (c <= 0x007F)) {
			utflen++;
		} else if (c > 0x07FF) {
			utflen += 3;
		} else {
			utflen += 2;
		}
	}

	return utflen;
}

public function int writeUTF(String str) 
{
	local int strlen, utflen, c, i; 
	strlen = Len(str);
	utflen = utfSizeOf(str);
	c = 0;

	if (utflen > 65535)
		`warn("encoded string too long: " $ utflen $ " bytes");

	writeShort(utflen);

	for (i=0; i<strlen; i++) {
		c = Asc(Mid(str, i, 1));
		if (!((c >= 0x0001) && (c <= 0x007F))) break;
		writeByte(byte (c));
	}

	for (i = i;i < strlen; i++){
		c = Asc(Mid(str, i, 1));
		if ((c >= 0x0001) && (c <= 0x007F)) {
			writeByte(byte (c));

		} else if (c > 0x07FF) {
			writeByte(byte (0xE0 | ((c >> 12) & 0x0F)));
			writeByte(byte (0x80 | ((c >>  6) & 0x3F)));
			writeByte(byte (0x80 | ((c) & 0x3F)));
		} else {
			writeByte(byte (0xC0 | ((c >>  6) & 0x1F)));
			writeByte(byte (0x80 | ((c) & 0x3F)));
		}
	}

	return utflen + 2;
}

public function String readUTF()
{
	return readUTFFrom(self);
}

public static function String readUTFFrom(ByteArray in)
{
	local int utflen;
	utflen = in.readShort();

	return readUTFFromWithRange(in, in.position, utflen);
}

public static function String readUTFFromWithRange(ByteArray in, int offset, int utflen)
{
	local int c, char2, char3;
	local int count;

	local Array<byte> bytearr;
	local String chararr;

	bytearr.Length = utflen * 2;

	bytearr = in.read(offset, utflen);

	while (count < utflen) {
		c = bytearr[count] & 0xff;
		if (c > 127) break;
		count++;
		chararr $= Chr(c);
	}

	while (count < utflen) {
		c = bytearr[count] & 0xff;
		switch (c >> 4) {
			case 0: case 1: case 2: case 3: case 4: case 5: case 6: case 7:
                /* 0xxxxxxx*/
				count++;
				chararr$=Chr(c);
				break;
			case 12: case 13:
                /* 110x xxxx   10xx xxxx*/
				count += 2;
				if (count > utflen)
					`warn("malformed input: partial character at end");
				char2 = int(bytearr[count-1]);
				if ((char2 & 0xC0) != 0x80)
					`warn("malformed input around byte " $ count);
				chararr$=Chr(((c & 0x1F) << 6) |	(char2 & 0x3F));
				break;
			case 14:
                /* 1110 xxxx  10xx xxxx  10xx xxxx */
				count += 3;
				if (count > utflen)
					`warn("malformed input: partial character at end");

				char2 = int(bytearr[count-2]);
				char3 = int(bytearr[count-1]);

				if (((char2 & 0xC0) != 0x80) || ((char3 & 0xC0) != 0x80))
					`warn("malformed input around byte " $ (count-1));
				chararr $= Chr(((c     & 0x0F) << 12) | ((char2 & 0x3F) << 6)  | ((char3 & 0x3F)));
				break;
			default:
                /* 10xx xxxx,  1111 xxxx */
				`warn("malformed input around byte " $ count);
		}
	}
	// The number of chars produced may be less than utflen
	in.position+=utflen;
	return chararr;
}


DefaultProperties
{

}
