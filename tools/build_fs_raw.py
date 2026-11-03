import zipfile, zlib, struct, sys
src, mani, dex3, out = sys.argv[1:5]
SO='lib/arm64-v8a/libduckstation.so'; OFF=0x1b7868
raw=open(src,'rb').read(); z=zipfile.ZipFile(src)
ents=[]  # name, method, crc, csize, usize, data, dostime, dosdate, extattr
for i in z.infolist():
    if i.filename.startswith('META-INF/'): continue
    name=i.filename
    if name in ('AndroidManifest.xml',SO):
        d=open(mani,'rb').read() if name=='AndroidManifest.xml' else bytearray(z.read(SO))
        if name==SO:
            assert bytes(d[OFF:OFF+4])==bytes.fromhex('f65b0736'); d[OFF:OFF+4]=bytes.fromhex('1f2003d5'); d=bytes(d)
        if i.compress_type==0: m,data=0,d
        else:
            c=zlib.compressobj(9,zlib.DEFLATED,-15); data=c.compress(d)+c.flush(); m=8
        ents.append([name,m,zlib.crc32(d),len(data),len(d),data,i])
    else:
        o=i.header_offset; nl,el=struct.unpack('<HH',raw[o+26:o+30]); s=o+30+nl+el
        ents.append([name,i.compress_type,i.CRC,i.compress_size,i.file_size,raw[s:s+i.compress_size],i])
d=open(dex3,'rb').read(); c=zlib.compressobj(9,zlib.DEFLATED,-15); data=c.compress(d)+c.flush()
ents.append(['classes3.dex',8,zlib.crc32(d),len(data),len(d),data,None])
f=open(out,'wb'); cd=[]
for name,m,crc,cs,us,data,i in ents:
    nb=name.encode(); off=f.tell(); pad=0
    if m==0:
        al=16384 if name.endswith('.so') else 4
        pad=(-(off+30+len(nb)))%al
        if 0<pad<4: pad+=al
    extra=struct.pack('<HH',0xD935,pad-4)+b'\0'*(pad-4) if pad else b''
    dt,dd=(i.date_time if i else (1981,1,1,0,0,0)), None
    t=(dt[3]<<11)|(dt[4]<<5)|(dt[5]//2); dte=((dt[0]-1980)<<9)|(dt[1]<<5)|dt[2]
    fl=0x800 if any(ord(ch)>127 for ch in name) else 0
    f.write(struct.pack('<IHHHHHIIIHH',0x04034b50,20,fl,m,t,dte,crc,cs,us,len(nb),len(extra))+nb+extra+data)
    ea=i.external_attr if i else (0o644<<16)
    cd.append(struct.pack('<IHHHHHHIIIHHHHHII',0x02014b50,(3<<8)|20,20,fl,m,t,dte,crc,cs,us,len(nb),len(extra),0,0,0,ea,off)+nb+extra)
start=f.tell(); blob=b''.join(cd); f.write(blob)
f.write(struct.pack('<IHHHHIIH',0x06054b50,0,0,len(cd),len(cd),len(blob),start,0)); f.close()
