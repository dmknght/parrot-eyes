import nimpy
import cores / [gensum, parsedb]


proc eyesGetMD5*(file_path: string): string {.exportpy.} =
  return getFileMd5(file_path)


proc eyesParseDb*(): seq[string] {.exportpy.} =
  return getDebChecksums()
