import nimpy
import cores / [gensum, parsedb]
import sequtils


proc eyesGetMD5*(file_path: string): string {.exportpy.} =
  return getFileMd5(file_path)


proc eyesParseDb*(): seq[string] {.exportpy.} =
  return getDebChecksums()


proc eyesCmpDb*(checksum: string, db: seq[string]): bool {.exportpy.} =
  if checksum in db:
    return true
  return false