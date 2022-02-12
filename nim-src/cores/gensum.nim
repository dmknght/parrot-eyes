#[
  Generate md5sum for all files. Goal: fast speed, no memory hungry
]#
import md5
import posix


proc getFileMd5*(file_path: string): string =
  # Safe calculating md5sum without eating memory
  if access(file_path, R_OK) != F_OK:
    stderr.write("[!] File is not readable. Exit!\n")
    return ""
  else:
    const szBuff = 16384 # 2 ** 14
    var
      f: File
      context: MD5Context
      buffer = newString(szBuff)

    context.md5Init()
    try:
      f = open(file_path, fmRead)
      while true:
        let readBytes = f.readChars(buffer.toOpenArray(0, szBuff - 1))
        context.md5Update(cstring(buffer), readBytes)
        if readBytes < szBuff:
          break

      var digest: MD5Digest
      context.md5Final(digest)
      return $digest
    except:
      return ""
